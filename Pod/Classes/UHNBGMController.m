//
//  UHNBGMController.m
//  UHNBGMController
//
//  Created by Nathaniel Hamming on 2013-04-30.
//  Copyright (c) 2015 University Health Network.
//

#import "UHNBGMController.h"
#import "UHNBLEController.h"
#import "NSData+BGMParser.h"
#import "NSData+RACPCommands.h"
#import "NSData+RACPParser.h"
#import "UHNDebug.h"

//#import "GlucoseLEProfileCommandBuilder.h"
//#import "GlucoseLEProfileParser.h"

@interface UHNBGMController() <UHNBLEControllerDelegate>
@property(nonatomic,strong) UHNBLEController *bleController;
@property(nonatomic,strong) NSUUID *deviceIdentifier;
@property(nonatomic,strong) NSString *bgmDeviceName;
@property(nonatomic,assign) BOOL shouldBlockReconnect;
//@property(nonatomic,retain) GlucoseLEProfileCommandBuilder *commandBuilder;
//@property(nonatomic,retain) GlucoseLEProfileParser *parser;
@property(nonatomic,strong) NSMutableData *inputBuffer;
@property(nonatomic,assign) NSUInteger features;
@property(nonatomic,assign) NSInteger numberOfRecords;
@property(nonatomic,weak) id<UHNBGMControllerDelegate> delegate;
@end

@implementation UHNBGMController

#pragma mark - Initialization of a UHNBGMController

- (id)init;
{
    [NSException raise:NSInvalidArgumentException
                format:@"%s: Use %@ instead", __PRETTY_FUNCTION__, NSStringFromSelector(@selector(initWithDelegate:))];
    return nil;
}

- (id)initWithDelegate:(id<UHNBGMControllerDelegate>)delegate;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    // only include the required services
    return [self initWithDelegate:delegate requiredServices:@[kGlucoseServiceUUID]];
}

- (instancetype)initWithDelegate:(id<UHNBGMControllerDelegate>)delegate requiredServices:(NSArray*)serviceUUIDs;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    
    // add the mandatory services, if they do not already exist
    BOOL didFindGlucoseService = NO;
    NSMutableArray *requiredServices = [serviceUUIDs mutableCopy];
    for (NSString *serviceUUID in serviceUUIDs) {
        if ([serviceUUID isEqualToString:kGlucoseServiceUUID]) {
            didFindGlucoseService = YES;
        }
    }
    if (didFindGlucoseService == NO) {
        [requiredServices addObject:kGlucoseServiceUUID];
    }
    
    if ((self = [super init])) {
        self.delegate = delegate;
        self.bleController = [[UHNBLEController alloc] initWithDelegate:self
                                                       requiredServices:requiredServices];
        self.shouldBlockReconnect = YES;
        self.inputBuffer = [NSMutableData data];
        self.features = 0;
        self.numberOfRecords = -1;
    }
    return self;
}

#pragma mark - Connection Methods

- (BOOL)isConnected;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    return self.bleController.isPeripheralConnected;
}

- (void)tryToReconnect;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    if (self.deviceIdentifier)
    {
        DLog(@"trying to reconnect");
        [self.bleController reconnectToPeripheralWithUUID:self.deviceIdentifier];
    } else {
        // note: BTLE will automatically start scanning when manager BT is available.
        [self.bleController startConnection];
    }
}

- (void)connectToDevice:(NSString*)deviceName;
{
    [self.bleController connectToDiscoveredPeripheral:deviceName];
}

- (void)disconnect;
{
    DLog(@"%s", __PRETTY_FUNCTION__);
    if ([self.bleController isPeripheralConnected]) {
        DLog(@"going to cancel BTLE connection");
        self.shouldBlockReconnect = YES;
        [self.bleController cancelConnection];
    }
}

#pragma mark - Feature characteristic methods

- (BOOL) isLowBatterySupported {
    return (self.features & GlucoseFeatureSupportedLowBattery);
}

- (BOOL) isMultipleBondSupporter {
    return (self.features & GlucoseFeatureSupportedMultipleBonds);
}

- (BOOL) isGeneralDeviceFaultSupported {
    return (self.features & GlucoseFeatureSupportedFaultDevice);
}

- (BOOL) isSensorMalfunctionDetectionSupported {
    return (self.features & GlucoseFeatureSupportedDetectionSensorMalfunction);
}

- (BOOL) isSensorReadInterruptDetectionSupported {
    return (self.features & GlucoseFeatureSupportedDetectionSensorReadInterrupt);
}

- (BOOL) isSensorResultHighLowDetectionSupported {
    return (self.features & GlucoseFeatureSupportedDetectionResultExceedsSensorLimit);
}

- (BOOL) isSensorSampleSizeSupported {
    return (self.features & GlucoseFeatureSupportedSensorSampleSize);
}

- (BOOL) isSensorStripInsertionErrorDetectionSupported {
    return (self.features & GlucoseFeatureSupportedDetectionStripErrorInsertion);
}

- (BOOL) isSensorStripTypeErrorDetectionSupported {
    return (self.features & GlucoseFeatureSupportedDetectionStripErrorType);
}

- (BOOL) isSensorTemperatureHighLogDetectionSupported {
    return (self.features & GlucoseFeatureSupportedDetectionSensorTemperatureTooLowHigh);
}

- (BOOL) isTimeFaultSupported {
    return (self.features & GlucoseFeatureSupportedFaultTime);
}

#pragma mark - RACP Methods

- (void) getNumberOfRecords {
    self.numberOfRecords = -1;
    NSData *command = [NSData reportNumberOfAllStoredRecords];
    [self.bleController writeValue:command toCharacteristicUUID:kGlucoseCharacteristicUUIDRACP withServiceUUID:kGlucoseServiceUUID];
}

- (void) getAllRecords {
    NSData *command = [NSData reportAllStoredRecords];
    [self.bleController writeValue:command toCharacteristicUUID:kGlucoseCharacteristicUUIDRACP withServiceUUID:kGlucoseServiceUUID];
}

#pragma mark - BLE Controller Delegate Methods

- (void)bleController:(UHNBLEController*)controller didDiscoverPeripheral:(NSString*)deviceName services:(NSArray*)serviceUUIDs RSSI:(NSNumber*)RSSI;
{
    DLog(@"Did discover glucose meter %@ (%@)", deviceName, RSSI);
    if ([self.delegate respondsToSelector: @selector(bgmController:didDiscoverGlucoseMeterWithName:services:RSSI:)]) {
        [self.delegate bgmController:self didDiscoverGlucoseMeterWithName:deviceName services:serviceUUIDs RSSI:RSSI];
    }
}

- (void)bleController:(UHNBLEController*)controller didDiscoverServices:(NSArray*)serviceUUIDs
{
    DLog(@"Did discover glucose meter services %@", serviceUUIDs);
}

- (void)bleController:(UHNBLEController*)controller didConnectWithPeripheral:(NSString*)deviceName withServices:(NSArray*)services andUUID:(NSUUID*)uuid
{
    self.deviceIdentifier = uuid;
    self.bgmDeviceName = deviceName;
    self.shouldBlockReconnect = NO;
    DLog(@"Did connect with %@ with services: %@ and UUID: %@", deviceName, services, uuid.UUIDString);
}

- (void)bleController:(UHNBLEController*)controller didDisconnectFromPeripheral:(NSString*)deviceName
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

- (void)bleController:(UHNBLEController*)controller failedToConnectWithPeripheral:(NSString*)deviceName
{
    DLog(@"Failed to connect with %@", deviceName);
}


- (void)bleController:(UHNBLEController*)controller didDiscoverCharacteristics:(NSArray*)characteristicUUIDs forService:(NSString*)serviceUUID
{
    DLog(@"Characteristics %@ discovered for service %@", characteristicUUIDs, serviceUUID);
    
    if ([serviceUUID isEqualToString:kGlucoseServiceUUID])
    {
        [self.bleController setNotificationState:YES forCharacteristicUUID:kGlucoseCharacteristicUUIDMeasurement withServiceUUID:kGlucoseServiceUUID];
    }
}

- (void)bleController:(UHNBLEController*)controller didUpdateNotificationState:(BOOL)notify forCharacteristic:(NSString*)charUUID
{
    DLog(@"Characteristic %@ notification state is %d", charUUID, notify);
    
    if ([charUUID isEqualToString:kGlucoseCharacteristicUUIDMeasurement]) {
        [self.bleController setNotificationState:notify forCharacteristicUUID:kGlucoseCharacteristicUUIDRACP withServiceUUID:kGlucoseServiceUUID];
    } else if ([charUUID isEqualToString:kGlucoseCharacteristicUUIDRACP]) {
        // start by reading the supported features
        [self.bleController readValueFromCharacteristicUUID:kGlucoseCharacteristicUUIDSupportedFeatures withServiceUUID:kGlucoseServiceUUID];
    }
}

- (void)bleController:(UHNBLEController*)controller didWriteValue:(NSData*)value toCharacteristic:(NSString*)charUUID
{
    DLog(@"Characteristic %@ was written %@", charUUID, value);
}

- (void)bleController:(UHNBLEController*)controller didUpdateValue:(NSData*)value forCharacteristic:(NSString*)charUUID
{
    DLog(@"Characteristic %@ did update %@", charUUID, value);

    if ([charUUID isEqualToString:kGlucoseCharacteristicUUIDSupportedFeatures]) {
        // store the enabled features
        // TODO should use the UHNBLEController NSData+ConvertionExtensions for parsing
        self.features = *(uint*)[value bytes];
        
        if ([self.delegate respondsToSelector:@selector(bgmController:didConnectToGlucoseMeterWithName:)])
        {
            [self.delegate bgmController:self didConnectToGlucoseMeterWithName:self.bgmDeviceName];
        }
    } else if ([charUUID isEqualToString:kGlucoseCharacteristicUUIDMeasurement]) {
        NSDictionary *glucoseMeasurementDetails = [value parseGlucoseMeasurementCharacteristicDetails];
        
        //TODO make a NSDictionary+BGMExtension category to help with querying the dictionary for information. (See NSData+RACPExtension)
//        [self.delegate bgmController:self didGetRecordWithValue:[glucoseMeasurementDetails glucoseConcentration] creationDate:[glucoseMeasurementDetails creationDate] unitsFormat:[glucoseMeasurementDetails unitsFormat] atIndex:[glucoseMeasurementDetails sequenceNumber]];
    } else if ([charUUID isEqualToString:kGlucoseCharacteristicUUIDRACP]) {
        NSDictionary *responseDict= [value parseRACPResponse];
        RACPOpCode responseOpCode = [responseDict[kRACPKeyResponseOpCode] unsignedIntegerValue];
        
        switch (responseOpCode) {
            case RACPOpCodeResponse:
            {
                NSDictionary *responseDetails = responseDict[kRACPKeyResponseCodeDetails];
                RACPResponseCode responseCode = [responseDetails[kRACPKeyResponseCode] unsignedIntegerValue];
                RACPOpCode requestOpCode = [responseDetails[kRACPKeyRequestOpCode] unsignedIntegerValue];
                if (responseCode == RACPSuccess) {
                    if ([self.delegate respondsToSelector:@selector(bgmController:RACPOperationSuccessful:)]) {
                        [self.delegate bgmController:self RACPOperationSuccessful:requestOpCode];
                    }
                    [self notifyDelegateRACPOpCodeSuccess:requestOpCode];
                } else {
                    if ([self.delegate respondsToSelector:@selector(bgmController:RACPOperation:failed:)]) {
                        [self.delegate bgmController:self RACPOperation:requestOpCode failed:responseCode];
                    }
                }
                break;
            }
            case RACPOpCodeResponseStoredRecordsReportNumber:
            {
                if ([self.delegate respondsToSelector: @selector(bgmController:didGetNumberOfStoredRecords:)]) {
                    NSNumber *value = responseDict[kRACPKeyNumberOfRecords];
                    [self.delegate bgmController:self didGetNumberOfStoredRecords:value];
                }
                break;
            }
            default:
                break;
        }
    }
}

- (void)notifyDelegateRACPOpCodeSuccess:(RACPOpCode)requestOpCode
{
    switch (requestOpCode) {
        case RACPOpCodeStoredRecordsReport:
            if ([self.delegate respondsToSelector:@selector(bgmControllerDidGetStoredRecords:)]) {
                [self.delegate bgmControllerDidGetStoredRecords:self];
            }
            break;
        default:
            DLog(@"I do not know about requested RACP op code %d", requestOpCode);
            break;
    }
}

@end
