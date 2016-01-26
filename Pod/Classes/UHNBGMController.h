//
//  UHNBGMController.h
//  UHNBGMController
//
//  Created by Nathaniel Hamming on 2013-04-30.
//  Copyright (c) 2016 University Health Network.
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

/**
 The UHNBGMController provides an interface to a BLE peripheral that implements the Glucose Service and Device Information services. Through the inteface and delegate protocol, one should be able to easily make requests of a Glucose meter sensor.
 
 @warning Support for Device Information services will be included in a future release.
 
 */

@interface UHNBGMController : NSObject

///-----------------------------------------
/// @name Initialization of UHNBGMController
///-----------------------------------------

/**
 UHNBGMController is initialized with a delegate and optional required services. If only the Glucose profile mandatory services are required, initialize using `initWithDelegate:`. Mandatory services include GLS and DIS.
 
 @param delegate The delegate object that will received discovery, connectivity, and read/write events. This parameter is mandatory.
 
 @return Instance of a UHNBGMController
 
 */
- (instancetype)initWithDelegate:(id<UHNBGMControllerDelegate>)delegate;

/**
 UHNBGMController is initialized with a delegate and optional required services.
 
 @param delegate The delegate object that will received discovery, connectivity, and read/write events. This parameter is mandatory.
 @param serviceUUIDs The required services used to filter eligibility of discovered peripherals. Only peripherals that advertist all the required services will be deemed eligible and reported to the delegate. If `services` is `nil`, only the peripherals discovered with the mandatory Glucose profile services will be reported to the delegate. Mandatory services include GLS and DIS.
 
 @return Instance of a UHNBGMController
 
 */
- (instancetype)initWithDelegate:(id<UHNBGMControllerDelegate>)delegate requiredServices:(NSArray*)serviceUUIDs;

///-------------------------
/// @name Connection Methods
///-------------------------
/**
 Determine if a glucose sensor is connected
 
 @return `YES` if a glucose sensor is connected, otherwise `NO`
 
 */
- (BOOL)isConnected;

/**
 Try to reconnect to the previously connected glucose sensor
 */
- (void)tryToReconnect;

/**
 Try to connect to the glucose sensor advertising the device name
 
 @param deviceName The name of the device with which a connection is desired. Device names are reported when the glucose sensors are discovered.
 
 */
- (void)connectToDevice:(NSString*)deviceName;

/**
 Disconnect from the connected glucose sensor
 */
- (void)disconnect;

///-------------------------
/// @name Supported Features
///-------------------------

/**
 Get the features of the connected glucose sensor
 
 @discussion `getGlucoseFeatures` needs to be called before any checks of the supported features
 */
- (void) getGlucoseFeatures;

/**
 Check if detection of low battery is suported by the connected glucose sensor
 
 @return `YES` if low battery detection is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isLowBatterySupported;

/**
 Check if multiple bonds is supported
 
 @return `YES` if multiple bonds is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isMultipleBondSupporter;

/**
 Check if general device fault is supported
 
 @return `YES` if general device fault is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isGeneralDeviceFaultSupported;

/**
 Check if detection of a sensor malfunction is supported
 
 @return `YES` if detection of a sensor malfunction is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isSensorMalfunctionDetectionSupported;

/**
 Check if detection of a sensor read interrupt is supported
 
 @return `YES` if detection of a sensor read interrupt is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isSensorReadInterruptDetectionSupported;

/**
 Check if result exceeds low or high limits detection is supported
 
 @return `YES` if result exceeds low or high limits detection is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isSensorResultHighLowDetectionSupported;

/**
 Check if sensor sample size is supported
 
 @return `YES` if sensor sample size is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isSensorSampleSizeSupported;

/**
 Check if strip insertion error detection is supported
 
 @return `YES` if strip insertion error detection is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isSensorStripInsertionErrorDetectionSupported;

/**
 Check if strip type error detection is supported
 
 @return `YES` if strip type error detection is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isSensorStripTypeErrorDetectionSupported;

/**
 Check if sensor temperature too high or low detection is supported
 
 @return `YES` if sensor temperature too high or low detection is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isSensorTemperatureHighLogDetectionSupported;

/**
 Check if time fault detection is supported
 
 @return `YES` if time fault detection is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` needs to be called first in order to read the Features characteristic
 */
- (BOOL) isTimeFaultSupported;

/**
 Check if glucose measurement context is supported
 
 @return `YES` if glucose measurement context is supported, otherwise `NO`
 
 @discussion `getGlucoseFeatures` does NOT need to be called first in order to determine if glucose measurement context support is provided
 */
- (BOOL) isGlucoseMeasurementContextSupported;

///----------------------------------
/// @name Glucose Service Characteristics
///----------------------------------
/**
 Request that the glucose measurement, glucose measurement context and RACP characteristics notifcations should be enabled or disabled
 
 @param enable If `YES` indicates that the notifications should be enabled. `NO` indicates that the notifications should be disabled
 
 @discussion If `enableAllNotifications:` is completed successfully, the delegete will receive the `bgmController:didSetNotificationStateForAllNotifications:` notification
 
 */
- (void) enableAllNotifications:(BOOL) enable;

/**
 Request that the glucose measurement characteristic notifcations should be enabled or disabled
 
 @param enable If `YES` indicates that the notification should be enabled. `NO` indicates that the notification should be disabled
 
 @discussion If `enableNotificationGlucoseMeasurement:` is completed successfully, the delegete will receive the `bgmController:didSetNotificationStateGlucoseMeasurement:` notification
 
 */
- (void) enableNotificationGlucoseMeasurement:(BOOL) enable;

/**
 Request that the glucose measurement context characteristic notifcations should be enabled or disabled
 
 @param enable If `YES` indicates that the notification should be enabled. `NO` indicates that the notification should be disabled
 
 @discussion If `enableNotificationGlucoseMeasurementContext:` is completed successfully, the delegete will receive the `bgmController:didSetNotificationStateGlucoseMeasurementContext:` notification
 
 */
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

/**
 Request to get the number of all the stored records from the glucose sensor
 
 @discussion If `getNumberOfStoredRecords` is completed successfully, the delegete will receive the `bgmController:didGetNumberOfRecords:` notification
 
 @discussion If 'getNumberOfStoredRecords` is unsuccessful, the delegate will receive the `bgmController:RACPOperation:failed:` notification.
 
 */
- (void) getNumberOfStoredRecords;

/**
 Request to get all stored records from the glucose sensor
 
 @discussion If `getAllStoredRecords` is completed successfully, the delegete will receive the `bgmController:RACPOperationSuccessful:` and/or `bgmController:didCompleteTransferWithNumberOfRecords:` notification (depending on which protocol methods are used). This is left up to the implementation.
 
 @discussion If 'getAllStoredRecords` is unsuccessful, the delegate will receive the `bgmController:RACPOperation:failed:` notification.
 
 */
- (void) getAllStoredRecords;

@end

/**
 The UHNBGMControllerDelegate protocol defines the methods that a delegate of a UHNBGMController object must adopt. The optional methods of the protocol allow the delegate to monitor, request, or command the Glucose sensor. The required methods of the protocol indicates discovery, connectivity, and reporting current glucose measurements with the Glucose sensor.
 
 */
@protocol UHNBGMControllerDelegate <NSObject, UHNRACPControllerDelegate>

/**
 Notifies the delegate when a Glucose sensor has been discovered
 
 @param controller The `UHNBGMController` which with the Glucose sensor was discovered
 @param bgmDeviceName The device name of the Glucose sensor
 @param serviceUUIDs An array of `NSString` representing the UUID of the services available for the Glucose sensor. This array includes all the provided required services and potentially additional services.
 @param RSSI The rssi power of the Glucose Sensor
 
 @discussion This method is invoked when a Glucose sensor with the required services is discovered. If required services were provided during instantiation, the only Glucose sensors with all of those services will be notified to the delegate. If no required services were provided, all discovered Glucose sensor offering the mandatory services will be notified to the delegate.
 
 */
- (void) bgmController:(UHNBGMController *) controller didDiscoverGlucoseMeterWithName:(NSString *) bgmDeviceName services:(NSArray *) serviceUUIDs RSSI:(NSNumber *) RSSI;

/**
 Notifies the delegate when a Glucose sensor did connect
 
 @param controller The `UHNBGMController` that is managing the Glucose sensor
 @param bgmDeviceName The device name of the Glucose sensor
 
 @discussion This method is invoked when a Glucose sensor is connected
 
 */
- (void) bgmController:(UHNBGMController *) controller didConnectToGlucoseMeterWithName:(NSString *) bgmDeviceName;

/**
 Notifies the delegate when a Glucose sensor was disconnected
 
 @param controller The `UHNBGMController` that was managing the Glucose sensor
 @param bgmDeviceName The device name of the peripheral
 
 @discussion This method is invoked when a Glucose sensor is disconnected
 
 */
- (void) bgmController:(UHNBGMController *) controller didDisconnectFromGlucoseMeter:(NSString *) bgmDeviceName;

/**
 Notifies the delegate that the requested get number of stored records has been completed successfully
 
 @param controller The `UHNBGMController` which with the RACP procedure was executed
 @param numberOfRecords The number of stored records
 
 @discussion This method is invoked when any of the RACP get number of stored records procedures has been completed successfully
 
 */
- (void) bgmController:(UHNBGMController *) controller didGetNumberOfRecords:(NSNumber *) numberOfRecords;

/**
 Notifies the delegate when a Glucose sensor has a measurement to report
 
 @param controller The `UHNBGMController` that is managing the Glucose sensor
 @param index The index of the record received
 @param measurementDetails A `NSDictionary` including all the measurement details
 
 @discussion This method is invoked when a Glucose sensor has a measurement to report. This measurement may be the most current measurement or a stored measurement as requested by a RACP get stored records procedure. The time information in the measurement details may help determine the age of the measurement.
 
 */
- (void) bgmController:(UHNBGMController *) controller didGetGlucoseMeasurementAtIndex:(NSUInteger) index withDetails:(NSDictionary *) measurementDetails;

/**
 Notifies the delegate when a Glucose sensor has a measurement context to report
 
 @param controller The `UHNBGMController` that is managing the Glucose sensor
 @param index The index of the record received
 @param measurementContextDetails A `NSDictionary` including all the measurement context details
 
 @discussion This method is invoked when a Glucose sensor has a measurement context to report. This measurement context may be the most current measurement context or a stored measurement context as requested by a RACP get stored records procedure.
 
 */
- (void) bgmController:(UHNBGMController *) controller didGetGlucoseMeasurementContextAtIndex:(NSUInteger) index withDetails:(NSDictionary *) measurementContextDetails;

/**
 Notifies the delegate that the requested get of stored records has been completed successfully
 
 @param controller The `UHNBGMController` which with the RACP procedure was executed
 @param numberOfRecords The number of records transferred
 
 @discussion This method is invoked when any of the RACP get stored records procedures has been completed successfully
 
 */
- (void) bgmController:(UHNBGMController *) controller didCompleteTransferWithNumberOfRecords:(NSUInteger) numberOfRecords;

@optional

/**
 Notifies the delegate when the Glucose sensor features characteristic has been read
 
 @param controller The `UHNBGMController` which with the characteristic was read
 
 @discussion This method is invoked when the Glucose Feature Characteristic has been read successfully
 
 @discussion For convinience, the UHNBGMController tracks the supported features to parse futher responses from the Glucose sensor
 
 */
- (void) bgmControllerDidGetSupportedFeatures:(UHNBGMController *) controller;

/**
 Notifies the delegate when the Glucose Measurement characteristic notification has been enabled or disabled
 
 @param controller The `UHNBGMController` which with the characteristic was configured
 @param enabled If `YES` indicates that the notification was enabled. `NO` indicates that the notification was disabled
 
 @discussion This method is invoked when the Glucose Measurement Characteristic notification has enabled or disabled
 
 @discussion The Glucose Measurement Characteristic needs to be enabled to received glucose measurements
 
 */
- (void) bgmController:(UHNBGMController *) controller didSetNotificationStateGlucoseMeasurement:(BOOL) enabled;

/**
 Notifies the delegate when the Glucose Measurement Context characteristic notification has been enabled or disabled
 
 @param controller The `UHNBGMController` which with the characteristic was configured
 @param enabled If `YES` indicates that the notification was enabled. `NO` indicates that the notification was disabled
 
 @discussion This method is invoked when the Glucose Measurement Context Characteristic notification has enabled or disabled
 
 @discussion The Glucose Measurement Context Characteristic needs to be enabled to received glucose measurements
 
 */
- (void) bgmController:(UHNBGMController *) controller didSetNotificationStateGlucoseMeasurementContext:(BOOL) enabled;

/**
 Notifies the delegate when all the characteristic notifications have been enabled or disabled
 
 @param controller The `UHNBGMController` which with the characteristics were configured
 @param enabled If `YES` indicates that all the notification were enabled. `NO` indicates that the notifications were disabled
 
 @discussion This method is invoked when all the characteristic notifications has enabled or disabled
 
 */
- (void) bgmController:(UHNBGMController *) controller didSetNotificationStateForAllNotifications:(BOOL) enabled;

@end