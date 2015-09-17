//
//  UHNBGMController.h
//  UHNBGMController
//
//  Created by Nathaniel Hamming on 2013-04-30.
//  Copyright (c) 2015 University Health Network.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "UHNRACPControllerDelegate.h"
#import "UHNBGMConstants.h"
#import "UHNRACPConstants.h"
#import "NSNumber+GlucoseConcentrationConversion.h"

@protocol UHNBGMControllerDelegate;


@interface UHNBGMController : NSObject

///-----------------------------------------
/// @name Initialization of UHNBGMControllerDelegate
///-----------------------------------------
- (instancetype)initWithDelegate:(id<UHNBGMControllerDelegate>)delegate;
- (instancetype)initWithDelegate:(id<UHNBGMControllerDelegate>)delegate requiredServices:(NSArray*)serviceUUIDs;

///-------------------------
/// @name Connection Methods
///-------------------------
- (BOOL)isConnected;
- (void)tryToReconnect;
- (void)connectToDevice:(NSString*)deviceName;
- (void)disconnect;

///-------------------------
/// @name Supported Features
///-------------------------

// Need to run "getGlucoseFeatures" in order to check what is supported
- (BOOL) isLowBatterySupported;
- (BOOL) isMultipleBondSupporter;
- (BOOL) isGeneralDeviceFaultSupported;
- (BOOL) isSensorMalfunctionDetectionSupported;
- (BOOL) isSensorReadInterruptDetectionSupported;
- (BOOL) isSensorResultHighLowDetectionSupported;
- (BOOL) isSensorSampleSizeSupported;
- (BOOL) isSensorStripInsertionErrorDetectionSupported;
- (BOOL) isSensorStripTypeErrorDetectionSupported;
- (BOOL) isSensorTemperatureHighLogDetectionSupported;
- (BOOL) isTimeFaultSupported;

// Don't need to run "getGlucoseFeatures" in order to check for this support 
- (BOOL) isGlucoseMeasurementContextSupported;

///----------------------------------
/// @name BGM Service Characteristics
///----------------------------------

- (void) enableAllNotifications:(BOOL) enable;
- (void) enableNotificationGlucoseMeasurement:(BOOL) enable;
- (void) enableNotificationGlucoseMeasurementContext:(BOOL) enable;

/**
 Request that the RACP characteristic indications should be enabled or disabled
 
 @param enable If `YES` indicates that the indications should be enabled. `NO` indicates that the indications should be disabled
 
 @discussion If `enableNotificationRACP:` is completed successfully, the delegete will receive the `bgmController:notificationRACP:` notification
 
 @discussion The BGM RACP Characteristic needs to be enabled to conduct RACP procedures. Also some RACP procedures also require BGM Measurement Characteristic notification enabled
 
 */

- (void) enableNotificationRACP:(BOOL) enable;

///----------------------------------
/// @name Record Access Control Point
///----------------------------------
- (void) getGlucoseFeatures;
- (void) getNumberOfStoredRecords;
- (void) getAllStoredRecords;

@end

@protocol UHNBGMControllerDelegate <NSObject, UHNRACPControllerDelegate>
- (void) bgmController:(UHNBGMController *) controller didDiscoverGlucoseMeterWithName:(NSString *) bgmDeviceName services:(NSArray *) serviceUUIDs RSSI:(NSNumber *) RSSI;
- (void) bgmController:(UHNBGMController *) controller didConnectToGlucoseMeterWithName:(NSString *) bgmDeviceName;
- (void) bgmController:(UHNBGMController *) controller didDisconnectFromGlucoseMeter:(NSString *) bgmDeviceName;
- (void) bgmController:(UHNBGMController *) controller didGetNumberOfRecords:(NSNumber *) numberOfRecords;
- (void) bgmController:(UHNBGMController *) controller didGetGlucoseMeasurementAtIndex:(NSUInteger) index withDetails:(NSDictionary *) measurementDetails;
- (void) bgmController:(UHNBGMController *) controller didGetGlucoseMeasurementContextAtIndex:(NSUInteger) index withDetails:(NSDictionary *) measurementContextDetails;
- (void) bgmController:(UHNBGMController *) controller didCompleteTransferWithNumberOfRecords:(NSUInteger) numberOfRecords;
@optional
- (void) bgmControllerDidGetSupportedFeatures:(UHNBGMController *) controller;
- (void) bgmControllerDidGetStoredRecords:(UHNBGMController *) controller;
- (void) bgmController:(UHNBGMController *) controller didSetNotificationStateGlucoseMeasurement:(BOOL) enabled;
- (void) bgmController:(UHNBGMController *) controller didSetNotificationStateGlucoseMeasurementContext:(BOOL) enabled;
- (void) bgmController:(UHNBGMController *) controller didSetNotificationStateForAllNotifications:(BOOL) enabled;

@end