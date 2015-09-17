//
//  ViewController.m
//  UHNBGMController
//
//  Created by Nathaniel Hamming on 02/26/2015.
//  Copyright (c) 2014 Nathaniel Hamming. All rights reserved.
//

#import "ViewController.h"
#import "UHNBGMController.h"
#import "UHNDebug.h"

@interface ViewController ()<UHNBGMControllerDelegate, UITableViewDataSource>
@property (nonatomic, strong) UHNBGMController *bgmController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) IBOutlet UIButton *startSessionButton;
@property (nonatomic, strong) IBOutlet UIButton *connectButton;
@property (nonatomic, strong) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfBGReadingsLabel;
@property (nonatomic, strong) IBOutlet UITableView *bgReadingsTable;
@property (nonatomic, strong) NSMutableArray *bgReadings;
@property (nonatomic, assign) BOOL glucoseReadingRequestStarted;
@property (nonatomic, assign) NSUInteger currentBgReadingIndex;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bgmController = [[UHNBGMController alloc] initWithDelegate: self];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.bgReadings = [NSMutableArray array];
    self.currentBgReadingIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction Methods

- (IBAction) connectButtonPressed:(id) sender;
{
    self.connectButton.enabled = NO;
    [self.bgmController tryToReconnect];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView;
{
    return 1;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section;
{
    return [self.bgReadings count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath;
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (indexPath.row < [self.bgReadings count])
    {
        NSDictionary *bgReadingDetails = [self.bgReadings objectAtIndex:indexPath.row];
        NSNumber *value = (NSNumber *) bgReadingDetails[kGlucoseMeasurementKeyGlucoseConcentration];
        NSNumber *unitsNumber = (NSNumber *) bgReadingDetails[kGlucoseMeasurementKeyGlucoseConcentrationUnits];
        
        GlucoseMeasurementGlucoseConcentrationUnits units = (GlucoseMeasurementGlucoseConcentrationUnits)[unitsNumber integerValue];
        
        // convert the value into standard units
        if (GlucoseMeasurementGlucoseConcentrationUnitsMmolPerL != units)
        {
            value = [value convertGlucoseConcentrationFromUnits:units toUnits:GlucoseMeasurementGlucoseConcentrationUnitsMmolPerL];
        }
        
        NSDate *creationDate = (NSDate *) bgReadingDetails[kGlucoseMeasurementKeyCreationDate];
        NSNumber *context = (NSNumber *) bgReadingDetails[kGlucoseMeasurementContextKeyCarbohydrateID];
        NSNumber *prePost = (NSNumber *) bgReadingDetails[kGlucoseMeasurementContextKeyMeal];
        NSString *contextString = @"";
        NSString *prePostString = @"";
        
        if (nil != prePost)
        {
            // set the pre/post string
            if (GlucoseMeasurementContextMealPreprandial == [prePost unsignedIntegerValue])
            {
                prePostString = NSLocalizedString(@"Pre ", nil);
            }
            else if (GlucoseMeasurementContextMealPostprandial == [prePost unsignedIntegerValue])
            {
                prePostString = NSLocalizedString(@"Post ", nil);
            }
        }
        
        if (nil != context)
        {
            // set the context string
            if (GlucoseMeasurementContextCarbohydrateIDBreakfast == [context unsignedIntegerValue])
            {
                contextString = NSLocalizedString(@"Breakfast ", nil);
            }
            else if (GlucoseMeasurementContextCarbohydrateIDLunch == [context unsignedIntegerValue])
            {
                contextString = NSLocalizedString(@"Lunch ", nil);
            }
            else if (GlucoseMeasurementContextCarbohydrateIDDinner == [context unsignedIntegerValue])
            {
                contextString = NSLocalizedString(@"Dinner ", nil);
            }
            else if (GlucoseMeasurementContextCarbohydrateIDSnack == [context unsignedIntegerValue])
            {
                contextString = NSLocalizedString(@"Snack ", nil);
            }
            else if (GlucoseMeasurementContextCarbohydrateIDDrink == [context unsignedIntegerValue])
            {
                contextString = NSLocalizedString(@"Drink ", nil);
            }
            else if (GlucoseMeasurementContextCarbohydrateIDSupper == [context unsignedIntegerValue])
            {
                contextString = NSLocalizedString(@"Supper ", nil);
            }
            else if (GlucoseMeasurementContextCarbohydrateIDBrunch == [context unsignedIntegerValue])
            {
                contextString = NSLocalizedString(@"Brunch ", nil);
            }
        }
        
        NSString *dateString = [self.dateFormatter stringFromDate:creationDate];
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@Reading %.2f mmol/L taken at %@", prePostString, contextString, [value doubleValue], dateString];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:8];
    }
    
    return cell;
}

#pragma mark - Glucose Profile Delegate Methods

- (void) bgmController:(UHNBGMController *) controller didDiscoverGlucoseMeterWithName:(NSString *) bgmDeviceName services:(NSArray *) serviceUUIDs RSSI:(NSNumber *) RSSI;
{
    DLog(@"%s: Device Name = %@ Services = %@ RSSI = %@", __PRETTY_FUNCTION__, bgmDeviceName, serviceUUIDs, RSSI);
    
    [self.bgmController connectToDevice:bgmDeviceName];
}

- (void) bgmController:(UHNBGMController *) controller didConnectToGlucoseMeterWithName:(NSString *) bgmDeviceName;
{
    DLog(@"%s: Device Name = %@", __PRETTY_FUNCTION__, bgmDeviceName);
    
    self.deviceNameLabel.text = bgmDeviceName;
    self.connectButton.enabled = NO;
    
    [self.bgmController getGlucoseFeatures];
}

- (void) bgmController:(UHNBGMController *) controller didDisconnectFromGlucoseMeter:(NSString *) bgmDeviceName;
{
    DLog(@"%s: Device Name = %@", __PRETTY_FUNCTION__, bgmDeviceName);
}

- (void) bgmController:(UHNBGMController *) controller didGetNumberOfRecords:(NSNumber *) numberOfRecords;

{
    DLog(@"%s: Number Of Records: %lu", __PRETTY_FUNCTION__, (unsigned long) [numberOfRecords integerValue]);
    
    self.numberOfBGReadingsLabel.text = [NSString stringWithFormat:@"%ld", (long)[numberOfRecords integerValue]];
    self.glucoseReadingRequestStarted = YES;
    [self.bgmController getAllStoredRecords];
}

- (void) bgmController:(UHNBGMController *) controller didGetGlucoseMeasurementAtIndex:(NSUInteger) index withDetails:(NSDictionary *) measurementDetails;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    [self.bgReadings addObject:measurementDetails];
    self.currentBgReadingIndex = (self.bgReadings.count - 1);
}

- (void) bgmController:(UHNBGMController *) controller didGetGlucoseMeasurementContextAtIndex:(NSUInteger) index withDetails:(NSDictionary *) measurementContextDetails;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableDictionary *glucoseReadingDetails = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *) self.bgReadings[self.currentBgReadingIndex]];
    NSNumber *value = nil;
    
    // insert the carbohydrate ID (ie. reading context)
    if (nil != (value = (NSNumber *) measurementContextDetails[kGlucoseMeasurementContextKeyCarbohydrateID]))
    {
        [glucoseReadingDetails setObject:value forKey:kGlucoseMeasurementContextKeyCarbohydrateID];
    }
    
    // insert the meal (ie. pre/post)
    if (nil != (value = (NSNumber *) measurementContextDetails[kGlucoseMeasurementContextKeyMeal]))
    {
        [glucoseReadingDetails setObject:value forKey:kGlucoseMeasurementContextKeyMeal];
    }
    
    // NOTE: If you want to insert more information, find it here.
    
    [self.bgReadings setObject:glucoseReadingDetails atIndexedSubscript:self.currentBgReadingIndex];
}

- (void) bgmController:(UHNBGMController *) controller didCompleteTransferWithNumberOfRecords:(NSUInteger) numberOfRecords;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    self.currentBgReadingIndex = 0;
}

- (void) bgmControllerDidGetSupportedFeatures:(UHNBGMController *) controller;
{
    [self.bgmController enableAllNotifications:YES];
}

#pragma mark - RACP Controller Delegate Methods

- (void) racpController:(id) controller RACPOperationSuccessful:(RACPOpCode) opCode;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
 
    if (self.glucoseReadingRequestStarted)
    {
        self.glucoseReadingRequestStarted = NO;
        [self.bgReadingsTable reloadData];
    }
}

- (void) racpController:(id) controller RACPOperation:(RACPOpCode) opCode failed:(RACPResponseCode) responseCode;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) bgmController:(UHNBGMController *) controller didGetNumberOfStoredRecords:(NSNumber *) numOfRecords;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) bgmController:(UHNBGMController *) controller didSetNotificationStateForAllNotifications:(BOOL) enabled;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    
    [self.bgmController getNumberOfStoredRecords];
}

@end
