    //
//  UHNBGMController.m
//  UHNBGMController
//
//  Created by Nathaniel Hamming on 2013-04-30.
//  Copyright (c) 2015 University Health Network.
//

#import "UHNBGMController.h"
#import "UHNBLEController.h"
#import "NSData+ConversionExtensions.h"
#import "NSData+GlucoseMeasurementParser.h"
#import "NSData+GlucoseMeasurementContextParser.h"
#import "NSData+RACPCommands.h"
#import "NSData+RACPParser.h"
#import "UHNDebug.h"

@interface UHNBGMController() <UHNBLEControllerDelegate>
@property (nonatomic, strong) UHNBLEController *bleController;
@property (nonatomic, strong) NSUUID *deviceIdentifier;
@property (nonatomic, strong) NSString *bgmDeviceName;
@property (nonatomic, assign) BOOL shouldBlockReconnect;
@property (nonatomic, assign) NSUInteger features;
@property (nonatomic, assign) BOOL enableAllNotifications;
@property (nonatomic, assign) BOOL isGlucoseMeasurementContextSupportedBySensor;
@property (nonatomic, assign) BOOL crcCheckingEnabled;
@property (nonatomic, assign) NSUInteger numberOfRecordsReceived;
@property (nonatomic, weak) id<UHNBGMControllerDelegate> delegate;
@end

@implementation UHNBGMController

#pragma mark - Initialization of a UHNBGMController

- (id) init;
{
    [NSException raise:NSInvalidArgumentException
                format:@"%s: Use %@ instead", __PRETTY_FUNCTION__, NSStringFromSelector(@selector(initWithDelegate:))];
    return nil;
}

- (id) initWithDelegate:(id<UHNBGMControllerDelegate>) delegate;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    NSArray *requiredServices = @[kGlucoseServiceUUID];
    
    // only include the required services
    return [self initWithDelegate:delegate requiredServices:requiredServices];
}

- (instancetype) initWithDelegate:(id<UHNBGMControllerDelegate>) delegate requiredServices:(NSArray *) serviceUUIDs;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    // add the mandatory services, if they do not already exist
    BOOL didFindGlucoseService = NO;
    
    NSMutableArray *requiredServices = [serviceUUIDs mutableCopy];
    
    for (NSString *serviceUUID in serviceUUIDs)
    {
        if ([serviceUUID isEqualToString:kGlucoseServiceUUID])
        {
            didFindGlucoseService = YES;
        }
    }
    
    if (NO == didFindGlucoseService)
    {
        [requiredServices addObject:kGlucoseServiceUUID];
    }

    if ((self = [super init]))
    {
        self.delegate = delegate;
        self.bleController = [[UHNBLEController alloc] initWithDelegate:self
                                                       requiredServices:requiredServices];
        self.shouldBlockReconnect = YES;
        self.enableAllNotifications = NO;
        self.isGlucoseMeasurementContextSupportedBySensor = NO;
        self.crcCheckingEnabled = NO;
        self.features = 0;
        self.numberOfRecordsReceived = 0;
    }
    
    return self;
}

#pragma mark - Connection Methods

- (BOOL) isConnected;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    return self.bleController.isPeripheralConnected;
}

- (void) tryToReconnect;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.deviceIdentifier)
    {
        DLog(@"trying to reconnect");
        [self.bleController reconnectToPeripheralWithUUID:self.deviceIdentifier];
    }
    else
    {
        // note: BTLE will automatically start scanning when manager BT is available.
        [self.bleController startConnection];
    }
}

- (void) connectToDevice:(NSString *) deviceName;
{
    [self.bleController connectToDiscoveredPeripheral:deviceName];
}

- (void) disconnect;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([self.bleController isPeripheralConnected])
    {
        DLog(@"going to cancel BTLE connection");
        self.shouldBlockReconnect = YES;
        [self.bleController cancelConnection];
    }
}

#pragma mark - Feature characteristic methods

- (BOOL) isLowBatterySupported;
{
    return (self.features & GlucoseFeatureSupportedLowBattery);
}

- (BOOL) isMultipleBondSupporter;
{
    return (self.features & GlucoseFeatureSupportedMultipleBonds);
}

- (BOOL) isGeneralDeviceFaultSupported;
{
    return (self.features & GlucoseFeatureSupportedFaultDevice);
}

- (BOOL) isSensorMalfunctionDetectionSupported;
{
    return (self.features & GlucoseFeatureSupportedDetectionSensorMalfunction);
}

- (BOOL) isSensorReadInterruptDetectionSupported;
{
    return (self.features & GlucoseFeatureSupportedDetectionSensorReadInterrupt);
}

- (BOOL) isSensorResultHighLowDetectionSupported;
{
    return (self.features & GlucoseFeatureSupportedDetectionResultExceedsSensorLimit);
}

- (BOOL) isSensorSampleSizeSupported;
{
    return (self.features & GlucoseFeatureSupportedSensorSampleSize);
}

- (BOOL) isSensorStripInsertionErrorDetectionSupported;
{
    return (self.features & GlucoseFeatureSupportedDetectionStripErrorInsertion);
}

- (BOOL) isSensorStripTypeErrorDetectionSupported;
{
    return (self.features & GlucoseFeatureSupportedDetectionStripErrorType);
}

- (BOOL) isSensorTemperatureHighLogDetectionSupported;
{
    return (self.features & GlucoseFeatureSupportedDetectionSensorTemperatureTooLowHigh);
}

- (BOOL) isTimeFaultSupported;
{
    return (self.features & GlucoseFeatureSupportedFaultTime);
}

- (BOOL) isGlucoseMeasurementContextSupported;
{
    return (self.isGlucoseMeasurementContextSupportedBySensor);
}

#pragma mark - Enable Notification State Methods

- (void) enableAllNotifications:(BOOL) enable;
{
    self.enableAllNotifications = YES;
    
    // enable all the notifications starting with the glucose measurement notification
    [self.bleController setNotificationState:enable forCharacteristicUUID:kGlucoseServiceCharacteristicUUIDMeasurement withServiceUUID:kGlucoseServiceUUID];
}

- (void) enableNotificationGlucoseMeasurement:(BOOL) enable;
{
    [self.bleController setNotificationState:enable forCharacteristicUUID:kGlucoseServiceCharacteristicUUIDMeasurement withServiceUUID:kGlucoseServiceUUID];
}

- (void) enableNotificationGlucoseMeasurementContext:(BOOL) enable;
{
    [self.bleController setNotificationState:enable forCharacteristicUUID:kGlucoseServiceCharacteristicUUIDMeasurementContext withServiceUUID:kGlucoseServiceUUID];
}

- (void) enableNotificationRACP:(BOOL) enable;
{
    [self.bleController setNotificationState:enable forCharacteristicUUID:kGlucoseServiceCharacteristicUUIDRecordAccessControlPoint withServiceUUID:kGlucoseServiceUUID];
}

#pragma mark - Record Access Control Point (RACP) Methods

- (void) sendRACPCommand:(NSData *) command
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([self isConnected])
    {
        [self.bleController writeValue:command toCharacteristicUUID:kGlucoseServiceCharacteristicUUIDRecordAccessControlPoint withServiceUUID:kGlucoseServiceUUID];
    }
    else
    {
        [self displayMessage:@"BGM not connected."];
    }
}

- (void) getGlucoseFeatures;
{
     // get the supported features
     [self.bleController readValueFromCharacteristicUUID:kGlucoseServiceCharacteristicUUIDSupportedFeatures withServiceUUID:kGlucoseServiceUUID];
}

- (void) getNumberOfStoredRecords;
{
    NSData *command = [NSData reportNumberOfAllStoredRecords];
    [self sendRACPCommand:command];
}

- (void) getAllStoredRecords;
{
    self.numberOfRecordsReceived = 0;
    NSData *command = [NSData reportAllStoredRecords];
    [self sendRACPCommand:command];
}

#pragma mark - BLE Controller Delegate Methods

- (void) bleController:(UHNBLEController *) controller didDiscoverPeripheral:(NSString *) deviceName services:(NSArray *) serviceUUIDs RSSI:(NSNumber *) RSSI;
{
    DLog(@"Did discover glucose meter %@ (%@)", deviceName, RSSI);
    
    if ([self.delegate respondsToSelector: @selector(bgmController:didDiscoverGlucoseMeterWithName:services:RSSI:)])
    {
        [self.delegate bgmController:self didDiscoverGlucoseMeterWithName:deviceName services:serviceUUIDs RSSI:RSSI];
    }
}

- (void) bleController:(UHNBLEController *) controller didDiscoverServices:(NSArray *) serviceUUIDs;
{
    DLog(@"Did discover glucose meter services %@", serviceUUIDs);
}

- (void) bleController:(UHNBLEController *) controller didConnectWithPeripheral:(NSString *) deviceName withServices:(NSArray *) services andUUID:(NSUUID *) uuid;
{
    self.deviceIdentifier = uuid;
    self.bgmDeviceName = deviceName;
    self.shouldBlockReconnect = NO;
    
    DLog(@"Did connect with %@ with services: %@ and UUID: %@", deviceName, services, uuid.UUIDString);
}

- (void) bleController:(UHNBLEController *) controller didDisconnectFromPeripheral:(NSString *) deviceName;
{
    DLog(@"Did cancel connection or disconnect with %@", deviceName);
    
    // try to reconnect
    if (!self.shouldBlockReconnect)
    {
        [self tryToReconnect];
    }
    
    self.shouldBlockReconnect = NO;
    
    if ([self.delegate respondsToSelector:@selector(bgmController:didDisconnectFromGlucoseMeter:)])
    {
        [self.delegate bgmController:self didDisconnectFromGlucoseMeter:self.bgmDeviceName];
    }
}

- (void) bleController:(UHNBLEController *) controller failedToConnectWithPeripheral:(NSString *) deviceName;
{
    DLog(@"Failed to connect with %@", deviceName);
}


- (void) bleController:(UHNBLEController *) controller didDiscoverCharacteristics:(NSArray *) characteristicUUIDs forService:(NSString *) serviceUUID;
{
    DLog(@"Characteristics %@ discovered for service %@", characteristicUUIDs, serviceUUID);
    
    if ([serviceUUID isEqualToString:kGlucoseServiceUUID])
    {
        // look for the "Glucose Measurement Context" characteristic
        for (NSString *characteristicUUID in characteristicUUIDs)
        {
            if ([characteristicUUID isEqualToString:kGlucoseServiceCharacteristicUUIDMeasurementContext])
            {
                self.isGlucoseMeasurementContextSupportedBySensor = YES;
                break;
            }
        }

        // notify the delegate that the meter was connected
        if ([self.delegate respondsToSelector:@selector(bgmController:didConnectToGlucoseMeterWithName:)])
        {
            [self.delegate bgmController:self didConnectToGlucoseMeterWithName:self.bgmDeviceName];
        }
    }
}

- (void) bleController:(UHNBLEController *) controller didUpdateNotificationState:(BOOL) notify forCharacteristic:(NSString *) characteristicUUID;
{
    DLog(@"Characteristic %@ notification state is %d", characteristicUUID, notify);

    // once glucose measurement notifications are set, either set glucose measurement context notifications (if they are supported) or set RACP notifications
    if ([characteristicUUID isEqualToString:kGlucoseServiceCharacteristicUUIDMeasurement])
    {
        [self handleNotificationStateUpdateToGlucoseMeasurement:notify];
    }
    // once glucose measurement context notifications are set, set the RACP notifications
    else if ([characteristicUUID isEqualToString:kGlucoseServiceCharacteristicUUIDMeasurementContext])
    {
        [self handleNotificationStateUpdateToGlucoseMeasurementContext:notify];
    }
    // once RACP notification is set, set notifications for GlucoseMeasurement
    if ([characteristicUUID isEqualToString:kGlucoseServiceCharacteristicUUIDRecordAccessControlPoint])
    {
        [self handleNotificationStateUpdateToRACP:notify];
    }
}

- (void) bleController:(UHNBLEController *) controller didWriteValue:(NSData *) value toCharacteristic:(NSString *) charUUID;
{
    DLog(@"Characteristic %@ was written %@", charUUID, value);
    
    if ([charUUID isEqualToString:kGlucoseServiceCharacteristicUUIDRecordAccessControlPoint])
    {
        DLog(@"RACP Characteristic was written");
    }
}

- (void) bleController:(UHNBLEController *) controller didUpdateValue:(NSData *) value forCharacteristic:(NSString *) charUUID;
{
    DLog(@"Characteristic %@ did update %@", charUUID, value);

    if ([charUUID isEqualToString:kGlucoseServiceCharacteristicUUIDSupportedFeatures])
    {
        [self handleCharacteristicUpdateToSupportedFeatures:value];
    }
    else if ([charUUID isEqualToString:kGlucoseServiceCharacteristicUUIDMeasurement])
    {
        [self handleCharacteristicUpdateToGlucoseMeasurement:value];
    }
    else if ([charUUID isEqualToString:kGlucoseServiceCharacteristicUUIDMeasurementContext])
    {
        [self handleCharacteristicUpdateToGlucoseMeasurementContext:value];
    }
    else if ([charUUID isEqualToString:kGlucoseServiceCharacteristicUUIDRecordAccessControlPoint])
    {
        [self handleCharacteristicUpdateToRACP:value];
    }
}

#pragma mark - BLE Notification State Update Handlers

- (void) handleNotificationStateUpdateToGlucoseMeasurement:(BOOL) notify;
{
    // if we need to enable all notifications, then enable them all
    if (self.enableAllNotifications)
    {
        // if glucose measurement context is supported, then set the notifications for it
        if (self.isGlucoseMeasurementContextSupportedBySensor)
        {
            [self.bleController setNotificationState:notify forCharacteristicUUID:kGlucoseServiceCharacteristicUUIDMeasurementContext withServiceUUID:kGlucoseServiceUUID];
        }
        // otherwise go straight to setting the RACP notifications
        else
        {
            [self.bleController setNotificationState:notify forCharacteristicUUID:kGlucoseServiceCharacteristicUUIDRecordAccessControlPoint withServiceUUID:kGlucoseServiceUUID];
        }
    }
    // otherwise enable one at a time and inform the delegate as they are enabled
    else
    {
        if ([self.delegate respondsToSelector:@selector(bgmController:didSetNotificationStateGlucoseMeasurement:)])
        {
            [self.delegate bgmController:self didSetNotificationStateGlucoseMeasurement:notify];
        }
    }
}

- (void) handleNotificationStateUpdateToGlucoseMeasurementContext:(BOOL) notify;
{
    // if we need to enable all notifications, then enable them all
    if (self.enableAllNotifications)
    {
        [self.bleController setNotificationState:notify forCharacteristicUUID:kGlucoseServiceCharacteristicUUIDRecordAccessControlPoint withServiceUUID:kGlucoseServiceUUID];
    }
    // otherwise enable one at a time and inform the delegate as they are enabled
    else
    {
        if ([self.delegate respondsToSelector:@selector(bgmController:didSetNotificationStateGlucoseMeasurementContext:)])
        {
            [self.delegate bgmController:self didSetNotificationStateGlucoseMeasurementContext:notify];
        }
    }
}

- (void) handleNotificationStateUpdateToRACP:(BOOL) notify;
{
    if (self.enableAllNotifications)
    {
        // turn off enable all notifications
        self.enableAllNotifications = NO;
        
        if ([self.delegate respondsToSelector:@selector(bgmController:didSetNotificationStateForAllNotifications:)])
        {
            [self.delegate bgmController:self didSetNotificationStateForAllNotifications:notify];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(racpController:didSetNotificationStateRACP:)])
        {
            [self.delegate racpController:self didSetNotificationStateRACP:notify];
        }
    }
}

#pragma mark - BLE Characteristic Update Handlers

- (void) handleCharacteristicUpdateToSupportedFeatures:(NSData *) value;
{
    // store the enabled features
    self.features = [value unsignedIntegerAtRange:NSMakeRange(0, 2)];
    
    // once the delegate gets this response, it can check the supported features
    if ([self.delegate respondsToSelector:@selector(bgmControllerDidGetSupportedFeatures:)])
    {
        [self.delegate bgmControllerDidGetSupportedFeatures:self];
    }
}

- (void) handleCharacteristicUpdateToGlucoseMeasurement:(NSData *) value;
{
    if ([self.delegate respondsToSelector:@selector(bgmController:didGetGlucoseMeasurementAtIndex:withDetails:)])
    {
        DLog(@"Did get data %@", value);
        
        self.numberOfRecordsReceived += 1;
        NSDictionary *glucoseMeasurementDetails = [value parseGlucoseMeasurementCharacteristicDetails:self.crcCheckingEnabled];
        NSNumber *sequenceNumber = (NSNumber *) glucoseMeasurementDetails[kGlucoseMeasurementKeySequenceNumber];
        [self.delegate bgmController:self didGetGlucoseMeasurementAtIndex:[sequenceNumber integerValue] withDetails:glucoseMeasurementDetails];
    }
}

- (void) handleCharacteristicUpdateToGlucoseMeasurementContext:(NSData *) value;
{
    if ([self.delegate respondsToSelector:@selector(bgmController:didGetGlucoseMeasurementContextAtIndex:withDetails:)])
    {
        DLog(@"Did get data %@", value);
        
        NSDictionary *glucoseMeasurementContextDetails = [value parseGlucoseMeasurementContextCharacteristicDetails:self.crcCheckingEnabled];
        NSNumber *sequenceNumber = (NSNumber *) glucoseMeasurementContextDetails[kGlucoseMeasurementContextKeySequenceNumber];
        [self.delegate bgmController:self didGetGlucoseMeasurementContextAtIndex:[sequenceNumber integerValue] withDetails:glucoseMeasurementContextDetails];
    }
}

- (void) handleCharacteristicUpdateToRACP:(NSData *) value;
{
    NSDictionary *responseDict= [value parseRACPResponse];
    RACPOpCode responseOpCode = [responseDict[kRACPKeyResponseOpCode] unsignedIntegerValue];
    
    switch (responseOpCode)
    {
        case RACPOpCodeResponse:
        {
            NSDictionary *responseDetails = responseDict[kRACPKeyResponseCodeDetails];
            RACPResponseCode responseCode = [responseDetails[kRACPKeyResponseCode] unsignedIntegerValue];
            RACPOpCode requestOpCode = [responseDetails[kRACPKeyRequestOpCode] unsignedIntegerValue];
            
            if (responseCode == RACPSuccess)
            {
                if ([self.delegate respondsToSelector:@selector(racpController:RACPOperationSuccessful:)])
                {
                    [self.delegate racpController:self RACPOperationSuccessful:requestOpCode];
                }
                
                [self notifyDelegateRACPOpCodeSuccess:requestOpCode];
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(racpController:RACPOperation:failed:)])
                {
                    [self.delegate racpController:self RACPOperation:requestOpCode failed:responseCode];
                }
            }
            
            break;
        }
        case RACPOpCodeResponseStoredRecordsReportNumber:
        {
            if ([self.delegate respondsToSelector: @selector(bgmController:didGetNumberOfRecords:)])
            {
                NSNumber *value = responseDict[kRACPKeyNumberOfRecords];
                [self.delegate bgmController:self didGetNumberOfRecords:value];
            }
            
            break;
        }
        case RACPOpCodeStoredRecordsReport:
        {
            if ([self.delegate respondsToSelector: @selector(bgmController:didGetNumberOfRecords:)])
            {
                NSNumber *value = responseDict[kRACPKeyNumberOfRecords];
                [self.delegate bgmController:self didGetNumberOfRecords:value];
            }
            
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void) notifyDelegateRACPOpCodeSuccess:(RACPOpCode) requestOpCode;
{
    switch (requestOpCode)
    {
        case RACPOpCodeStoredRecordsReport:
        {
            if ([self.delegate respondsToSelector:@selector(bgmController:didCompleteTransferWithNumberOfRecords:)])
            {
                [self.delegate bgmController:self didCompleteTransferWithNumberOfRecords:self.numberOfRecordsReceived];
            }
            
            break;
        }
        default:
        {
            DLog(@"I do not know about requested RACP op code %d", requestOpCode);
            break;
        }
    }
}

#pragma mark - Utility Methods

- (void) displayMessage:(NSString *) message;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
#ifdef DEBUG
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Data Transmission Error",@"Error title")
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                          otherButtonTitles:nil];
    [alert show];
#endif
}

@end
