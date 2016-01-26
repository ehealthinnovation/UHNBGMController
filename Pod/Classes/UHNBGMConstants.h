//
//  UHNBGMConstants.h
//  UHNBGMController
//
//  Created by kevin on 2013-01-08.
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


// Glucose UUIDs can be found here: http://developer.bluetooth.org/gatt/profiles/Pages/ProfileViewer.aspx?u=org.bluetooth.profile.glucose.xml

#import "UHNBLETypes.h"

///---------------------------
/// @name Glucose Service UUID
///---------------------------
#pragma mark - Glucose Service UUID
#define kGlucoseServiceUUID                                         @"1808"

///-------------------------------------------
/// @name Glucose Service Characteristic UUIDs
///-------------------------------------------
#pragma mark - Characteristic UUIDs
#define kGlucoseServiceCharacteristicUUIDMeasurement                @"2A18"
#define kGlucoseServiceCharacteristicUUIDMeasurementContext         @"2A34"
#define kGlucoseServiceCharacteristicUUIDSupportedFeatures          @"2A51"
#define kGlucoseServiceCharacteristicUUIDRecordAccessControlPoint   @"2A52"

///----------------------------------
/// @name Glucose Service Error Codes
///----------------------------------
#pragma mark - Error codes
#define kGlucoseServiceErrorCodeProcedureInProgress 0x80
#define kGlucoseServiceErrorCodeClientCharacteristicConfigDescriptorImproperlyConfigured 0x81

///---------------------------
/// @name Glucose Service Keys
///---------------------------
#pragma mark - Keys

/**
 Keys for Glucose Measurement
 */
#define kGlucoseMeasurementKeySequenceNumber                        @"GlucoseMeasurementKeySequenceNumber"
#define kGlucoseMeasurementKeyCreationDate                          @"GlucoseMeasurementKeyCreationDate"
#define kGlucoseMeasurementKeyTimeOffset                            @"GlucoseMeasurementKeyTimeOffset"
#define kGlucoseMeasurementKeyGlucoseConcentration                  @"GlucoseMeasurementKeyGlucoseConcentration"
#define kGlucoseMeasurementKeyGlucoseConcentrationUnits             @"GlucoseMeasurementKeyGlucoseConcentrationUnits"
#define kGlucoseMeasurementKeyType                                  @"GlucoseMeasurementKeyGlucoseType"
#define kGlucoseMeasurementKeySampleLocation                        @"GlucoseMeasurementKeyGlucoseSampleLocation"
#define kGlucoseMeasurementKeySensorStatusAnnunciation              @"GlucoseMeasurementKeyGlucoseSensorStatusAnnunciation"
#define kBGMCRCFailed                                               @"BGMCRCFailed"

/**
 Keys for Glucose Measurement Context
 */
#define kGlucoseMeasurementContextKeySequenceNumber                 @"GlucoseMeasurementContextKeySequenceNumber"
#define kGlucoseMeasurementContextKeyExtendedFlags                  @"GlucoseMeasurementContextKeyExtendedFlags"
#define kGlucoseMeasurementContextKeyCarbohydrateID                 @"GlucoseMeasurementContextKeyCarbohydrateID"
#define kGlucoseMeasurementContextKeyCarbohydrate                   @"GlucoseMeasurementContextKeyCarbohydrate"
#define kGlucoseMeasurementContextKeyMeal                           @"GlucoseMeasurementContextKeyMeal"
#define kGlucoseMeasurementContextKeyTester                         @"GlucoseMeasurementContextKeyTester"
#define kGlucoseMeasurementContextKeyHealth                         @"GlucoseMeasurementContextKeyHealth"
#define kGlucoseMeasurementContextKeyExerciseDuration               @"GlucoseMeasurementContextKeyExerciseDuration"
#define kGlucoseMeasurementContextKeyExerciseIntensity              @"GlucoseMeasurementContextKeyExerciseIntensity"
#define kGlucoseMeasurementContextKeyMedicationID                   @"GlucoseMeasurementContextKeyMedicationID"
#define kGlucoseMeasurementContextKeyMedicationValue                @"GlucoseMeasurementContextKeyMedicationValue"
#define kGlucoseMeasurementContextKeyMedicationUnits                @"GlucoseMeasurementContextKeyMedicationUnits"
#define kGlucoseMeasurementContextKeyHbA1c                          @"GlucoseMeasurementContextKeyHbA1c"

///-----------------------------------------
/// @name Glucose Measurement Characteristic
///-----------------------------------------
#pragma mark - Glucose Measurement Characteristic
/**********  Glucose Measurement Format (Mandatory) ***************
 Flags - 8 bits (Mandatory)
 - 0 (1) time offset present
 - 1 (1) glucose concentration, type and sample location present
 - 2 (1) glucose concentraiton units
 - 0 = kg/l
 - 1 = mol/l
 - 3 (1) sensor status annunciation present
 - 4 (1) context information follows
 - 5 (3) future use
 
 Sequence Number - uint16 (Mandatory)
 - Chronological order of the patient records in the Server (sensor) measurement database
 - Should not roll over
 - should not reset when database is cleared
 
 Base Time - org.bluetooth.characteristic.date_time (Mandatory)
 - year uint16 (Mandatory)
 - Min 1582
 - Max 9999
 - 0 = unknown
 - month uint8 (Mandatory)
 - Min 0
 - Max 12
 - 0 = unknown
 - day uint8 (Mandatory)
 - Min 0
 - Max 31
 - 0 = unkonwn
 - hours uint8 (Mandatory)
 - Min 0
 - Max 23
 - minutes uint8 (Mandatory)
 - Min 0
 - Max 60
 - seconds uint8 (Mandatory)
 - Min 0
 - Max 60
 
 Time Offset - uint16 (Field exists if the key of bit 0 of the Flags field is set to 1)
 - Units in minutes
 
 Glucose Concentration - SFLOAT (Field exists if the key of bit 1 of the Flags field is set to 1, Field exists if the key of bit 2 of the Flags field is set to 0)
 - Units in kg/l
 
 Glucose Concentration - SFLOAT (Field exists if the key of bit 1 of the Flags field is set to 1, Field exists if the key of bit 2 of the Flags field is set to 1)
 - Units in mol/l
 
 Type - nibble (Field exists if the key of bit 1 of the Flags field is set to 1)
 - 0 = Reserved for future use
 - 1 = Capillary Whole blood
 - 2 = Capillary Plasma
 - 3 = Venous Whole blood
 - 4 = Venous Plasma
 - 5 = Arterial Whole blood
 - 6 = Arterial Plasma
 - 7 = Undetermined Whole blood
 - 8 = Undetermined Plasma
 - 9 = Interstitial Fluid (ISF)
 - 10 = Control Solution
 - 11:15 = Reserved for future use
 
 Sample Location - nibble (Field exists if the key of bit 1 of the Flags field is set to 1)
 - 0 = Reserved for future use
 - 1 = Finger
 - 2 = Alternate Site Test (AST)
 - 3 = Earlobe
 - 4 = Control solution
 - 15 = Sample Location value not available
 - 5:14 = Reserved for future use
 
 Sensor Status Annunication - 16bit (Field exists if the key of bit 3 of the Flags field is set to 1)
 - 0 (1) Device battery low at time of measurement
 - 1 (1) Sensor malfunction or faulting at time of measurement
 - 2 (1) Sample size for blood or control solution insufficient at time of measurement
 - 3 (1) Strip insertion error
 - 4 (1) Strip type incorrect for device
 - 5 (1) Sensor result higher than the device can process
 - 6 (1) Sensor result lower than the device can process
 - 7 (1) Sensor temperature too high for valid test/result at time of measurement
 - 8 (1) Sensor temperature too low for valid test/result at time of measurement
 - 9 (1) Sensor read interrupted because strip was pulled too soon at time of measurement
 - 10 (1) General device fault has occurred in the sensor
 - 11 (1) Time fault has occurred in the sensor and time may be inaccurate
 - 12 (4) Reserved for future use
 
 **********************************************/

///------------------------------------------------------------
/// @name Glucose Measurement Characteristic Field Ranges and Sizes
///------------------------------------------------------------
/**
 Glucose measurement characteristic field ranges and sizes. Note that the ranges are type casted to make easy use in code
 */
#define kGlucoseMeasurementRangeFlags                           NSMakeRange(0, 1)
#define kGlucoseMeasurementRangeSequenceNumber                  NSMakeRange(1, 2)

///------------------------------------------------------
/// @name Glucose Measurement Characteristic Enumerations
///------------------------------------------------------

/**
 All possible Glucose Measurement Flag with their assigned bit position
 */
typedef NS_ENUM (uint8_t, GlucoseMeasurementFlagOption)
{
    /** Flag indicating that the time offset field is present in the measurement */
    GlucoseMeasurementFlagPresentTimeOffset                                     = (1 << 0),
    /** Flag indicating that the sample location and fluid type fields is present in the measurement */
    GlucoseMeasurementFlagPresentGlucoseConcentrationTypeAndSampleLocation      = (1 << 1),
    /** Flag indicating the glucose concentration units. Value of 0 = kg/L and value of 1 = mol/L */
    GlucoseMeasurementFlagGlucoseConcentrationUnits                             = (1 << 2),
    /** Flag indicating that the sensor status annunciation field is present in the measurement */
    GlucoseMeasurementFlagPresentSensorStatusAnnunciation                       = (1 << 3),
    /** Flag indicating that the glucose measurement context information will follow */
    GlucoseMeasurementFlagPresentContextInfo                                    = (1 << 4),
};

/** 
 Glucose Measurement Fluid Type: Fluid Type is defined in the UHNBLETypes.h constants in the UHNBLEController pod 
 */

/** 
 Glucose Measurement Sample Location: Sample location is defined in the UHNBLETypes.h constants in the UHNBLEController pod 
 */

/**
 All possible Glucose Measurement Sensor Status Flags with their assigned bit position
 */
typedef NS_ENUM (uint16_t, GlucoseMeasurementStatusOption)
{
    /** Flag indicating that the device battery level is low */
    GlucoseMeasurementStatusDeviceBatteryLow                                    = (1 << 0),
    /** Flag indicating that the sensor has malfunctioned */
    GlucoseMeasurementStatusSensorMalfunction                                   = (1 << 1),
    /** Flag indicating that the device battery level is low */
    GlucoseMeasurementStatusSampleSizeInsufficient                              = (1 << 2),
    /** Flag indicating that an error occurred during strip insertion */
    GlucoseMeasurementStatusStripInsertionError                                 = (1 << 3),
    /** Flag indicating that the strip type is incorrect */
    GlucoseMeasurementStatusStripTypeIncorrect                                  = (1 << 4),
    /** Flag indicating that the result exceeds the sensor upper limit */
    GlucoseMeasurementStatusResultExceedsSensorLimitUpper                       = (1 << 5),
    /** Flag indicating that the result exceeds the sensor lower limit */
    GlucoseMeasurementStatusResultExceedsSensorLimitLower                       = (1 << 6),
    /** Flag indicating that the device temperature is too high */
    GlucoseMeasurementStatusDeviceTemperatureTooHigh                            = (1 << 7),
    /** Flag indicating that the device temperature is too low */
    GlucoseMeasurementStatusDeviceTemperatureTooLow                             = (1 << 8),
    /** Flag indicating that the strip was pulled too soon */
    GlucoseMeasurementStatusStripPulledTooSoon                                  = (1 << 9),
    /** Flag indicating that a general fault occurred */
    GlucoseMeasurementStatusFaultGeneral                                        = (1 << 10),
    /** Flag indicating that a time fault occurred */
    GlucoseMeasurementStatusFaultTime                                           = (1 << 11)
};


///-------------------------------------------------
/// @name Glucose Measurement Context Characteristic
///-------------------------------------------------
#pragma mark - Glucose Measurement Context Characteristic
/**********  Glucose Measurement Context Format (Optional. Present if bit 4 of Glucose Measurement Flags is 1) ***************
 Flags - 8 bits (Mandatory)
 - 0 (1) Carbohydrate ID And Carbohydrate Present
 - 1 (1) Meal Present
 - 2 (1) Tester-Health Present
 - 3 (1) Exercise Duration And Exercise Intensity Present
 - 4 (1) Medication ID And Medication Present
 - 5 (3) Medication Value Units
 - 6 (1) HbA1c Present
 - 7 (1) Extended Flags Present
 
 Exrtended Flags - 8 bits (Field exists if the key of bit 7 of the Flags field is set to 1)
 - 0 (8) Reserved
 
 Carbohydrate ID - uint8 (Field exists if the key of bit 0 of the Flags field is set to 1)
 - 0 = Reserved for future use
 - 1 = Breakfast
 - 2 = Lunch
 - 3 = Dinner
 - 4 = Snack
 - 5 = Drink
 - 6 = Supper
 - 7 = Brunch
 - 8:255 = Reserved for future use
 
 Carbohydrate units of kilograms - SFLOAT (Field exists if the key of bit 0 of the Flags field is set to 1)
 - Units in kg
 - Exponent -3 (decimal)
 
 Meal - uint8 (Field exists if the key of bit 1 of the Flags field is set to 1)
 - 0 = Reserved for future use
 - 1 = Preprandial (before meal)
 - 2 = Postprandial (after meal)
 - 3 = Fasting
 - 4 = Casual (snacks, drinks, etc.)
 - 5 = Bedtime
 - 6:255 = Reserved for future use
 
 Tester - nibble (Field exists if the key of bit 2 of the Flags field is set to 1)
 - 0 = Reserved for future use
 - 1 = Minor health issues
 - 2 = Major health issues
 - 3 = During menses
 - 4 = Under stress
 - 5 = No health issues
 - 15 = Health value not available
 - 6:14 = Reserved for future use
 
 Exercise Duration - uint16 (Field exists if the key of bit 3 of the Flags field is set to 1)
 - Units in seconds
 - 65535 = Overrun
 
 Exercise Intensity - uint8 (Field exists if the key of bit 3 of the Flags field is set to 1)
 - Units in %
 
 Medication ID - uint8 (Field exists if the key of bit 4 of the Flags field is set to 1)
 - 0 = Reserved for future use
 - 1 = Rapid acting insulin
 - 2 = Short acting insulin
 - 3 = Intermediate acting insulin
 - 4 = Long acting insulin
 - 5 = Pre-mixed insulin
 - 6:255 = Reserved for future use
 
 Medication units of kilograms - SFLOAT (Field exists if the key of bit 4 of the Flags field is set to 1, C8: Field exists if the key of bit 5 of the Flags field is set to 0)
 - Units in kg
 - Exponent -6 (decimal)
 
 Medication units of liters - SFLOAT (Field exists if the key of bit 4 of the Flags field is set to 1, C9: Field exists if the key of bit 5 of the Flags field is set to 1)
 - Units in L
 - Exponent -3 (decimal)
 
 HbA1c - SFLOAT (Field exists if the key of bit 6 of the Flags field is set to 1)
 - Units in %
 
 **********************************************/

///------------------------------------------------------------------------
/// @name Glucose Measurement Context Characteristic Field Ranges and Sizes
///------------------------------------------------------------------------
/**
 Glucose measurement context characteristic field ranges and sizes. Note that the ranges are type casted to make easy use in code
 */
#define kGlucoseMeasurementContextRangeFlags                    NSMakeRange(0, 1)
#define kGlucoseMeasurementContextRangeSequenceNumber           NSMakeRange(1, 2)

///--------------------------------------------------------------
/// @name Glucose Measurement Context Characteristic Enumerations
///--------------------------------------------------------------

/**
 All possible Glucose Measurement Context Flags with their assigned bit position
 */
typedef NS_ENUM (uint8_t, GlucoseMeasurementContextFlagOption)
{
    /** Flag indicating the presence of the carbohydrate ID and carbohydrate value */
    GlucoseMeasurementContextFlagPresentCarbohydrateIDAndCarbohydrate           = (1 << 0),
    /** Flag indicating the presence of the meal ID */
    GlucoseMeasurementContextFlagPresentMeal                                    = (1 << 1),
    /** Flag indicating the presence of the tester and health ID */
    GlucoseMeasurementContextFlagPresentTesterHealth                            = (1 << 2),
    /** Flag indicating the presence of the exercise duration and exercise intensity */
    GlucoseMeasurementContextFlagPresentExerciseDurationAndExerciseIntensity    = (1 << 3),
    /** Flag indicating the presence of the medication ID and medication value */
    GlucoseMeasurementContextFlagPresentMedicationIDAndMedication               = (1 << 4),
    /** Flag indicating the presence of the medication units */
    GlucoseMeasurementContextFlagPresentMedicationUnits                         = (1 << 5),
    /** Flag indicating the presence of the HbA1c value */
    GlucoseMeasurementContextFlagPresentHbA1c                                   = (1 << 6),
    /** Flag indicating the presence of additional flags */
    GlucoseMeasurementContextFlagPresentExtendedFlags                           = (1 << 7),
};

/**
 All possible Glucose Measurement Context Carbohydrate IDs with their assigned bit position
 */
typedef NS_ENUM (NSUInteger, GlucoseMeasurementContextCarbohydrateID)
{
    /** Carbohydrate ID that is reservered */
    GlucoseMeasurementContextCarbohydrateIDReserved                 = 0,
    /** Carbohydrate ID for breakfast */
    GlucoseMeasurementContextCarbohydrateIDBreakfast,
    /** Carbohydrate ID for lunch */
    GlucoseMeasurementContextCarbohydrateIDLunch,
    /** Carbohydrate ID for dinner */
    GlucoseMeasurementContextCarbohydrateIDDinner,
    /** Carbohydrate ID for snack */
    GlucoseMeasurementContextCarbohydrateIDSnack,
    /** Carbohydrate ID for drink */
    GlucoseMeasurementContextCarbohydrateIDDrink,
    /** Carbohydrate ID for supper */
    GlucoseMeasurementContextCarbohydrateIDSupper,
    /** Carbohydrate ID for brunch */
    GlucoseMeasurementContextCarbohydrateIDBrunch,
};

/**
 All possible Glucose Measurement Context Meal IDs with their assigned bit position
 */
typedef NS_ENUM (NSUInteger, GlucoseMeasurementContextMeal)
{
    /** Meal ID that is reserved */
    GlucoseMeasurementContextMealReserved                           = 0,
    /** Meal ID for pre-prandial */
    GlucoseMeasurementContextMealPreprandial,
    /** Meal ID for post-prandial */
    GlucoseMeasurementContextMealPostprandial,
    /** Meal ID for fasting */
    GlucoseMeasurementContextMealFasting,
    /** Meal ID for casual */
    GlucoseMeasurementContextMealCasual,
    /** Meal ID for bedtime */
    GlucoseMeasurementContextMealBedtime,
};

/**
 All possible Glucose Measurement Context Tester IDs with their assigned bit position
 */
typedef NS_ENUM (NSUInteger, GlucoseMeasurementContextTester)
{
    /** Tester ID that is reserved */
    GlucoseMeasurementContextTesterReserved                         = 0,
    /** Tester ID for self */
    GlucoseMeasurementContextTesterSelf,
    /** Tester ID for health care professional */
    GlucoseMeasurementContextTesterHealthCareProfessional,
    /** Tester ID for lab test*/
    GlucoseMeasurementContextTesterLabTest,
    /** Tester ID for value not available*/
    GlucoseMeasurementContextTesterValueNotAvailable                = 15,
};

/**
 All possible Glucose Measurement Context Health IDs with their assigned bit position
 */
typedef NS_ENUM (NSUInteger, GlucoseMeasurementContextHealth)
{
    /** Health ID that is reserved */
    GlucoseMeasurementContextHealthReserved                         = 0,
    /** Health ID for minor health issues */
    GlucoseMeasurementContextHealthMinorHealthIssues,
    /** Health ID for major health issues */
    GlucoseMeasurementContextHealthMajoreHealthIssues,
    /** Health ID for during menses */
    GlucoseMeasurementContextHealthDuringMenses,
    /** Health ID for under stress */
    GlucoseMeasurementContextHealthUnderStress,
    /** Health ID for no health issues */
    GlucoseMeasurementContextHealthNoHealthIssues,
    /** Health ID for value not available */
    GlucoseMeasurementContextHealthValueNotAvailable                = 15,
};

/**
 All possible Glucose Measurement Context Medication IDs with their assigned bit position
 */
typedef NS_ENUM (NSUInteger, GlucoseMeasurementContextMedicationID)
{
    /** Medication ID that is reserved */
    GlucoseMeasurementContextMedicationIDReserved                   = 0,
    /** Medication ID for rapid acting insulin */
    GlucoseMeasurementContextMedicationIDRapidActingInsulin,
    /** Medication ID for short acting insulin */
    GlucoseMeasurementContextMedicationIDShortActingInsulin,
    /** Medication ID for intermediate acting insulin */
    GlucoseMeasurementContextMedicationIDIntermediateActingInsulin,
    /** Medication ID for long acting insulin */
    GlucoseMeasurementContextMedicationIDLongActingInsulin,
    /** Medication ID for pre-mixed insulin */
    GlucoseMeasurementContextMedicationIDPreMixedInsulin,
};

/**
 All possible Glucose Measurement Context Medication Units with their assigned bit position
 */
typedef NS_ENUM (NSUInteger, GlucoseMeasurementContextMedicationUnits)
{
    /** Medication units for kilograms (kg) */
    GlucoseMeasurementContextMedicationUnitsKg                      = 0,
    /** Medication units for litre (L) */
    GlucoseMeasurementContextMedicationUnitsL,
    /** Medication units for grams (g) */
    GlucoseMeasurementContextMedicationUnitsG,
};


///-------------------------------------------------
/// @name Glucose Sensor Feature Characteristic
///-------------------------------------------------
#pragma mark - Glucose Sensor Feature Characteristic
/**********  Glucose Sensor Feature (Mandatory) ***************
    Glucose Feature - 16 bit (Mandatory)
        - 0 (1) Low Battery Detection During Measurement Supported
        - 1 (1) Sensor Malfunction Detection Supported
        - 2 (1) Sensor Sample Size Supported
        - 3 (1) Sensor Strip Insertion Error Detection Supported
        - 4 (1) Sensor Strip Type Error Detection Supported
        - 5 (1) Sensor Result High-Low Detection Supported
        - 6 (1) Sensor Temperature High-Low Detection Supported
        - 7 (1) Sensor Read Interrupt Detection Supported
        - 8 (1) General Device Fault Supported
        - 9 (1) Time Fault Supported
        - 10 (1) Multiple Bond Supported
        - 11 (5) Reserved for future use
 
 **********************************************/

///--------------------------------------------------------------
/// @name Glucose Measurement Context Characteristic Enumerations
///--------------------------------------------------------------

/**
 All possible Feature Flags with their assigned bit position
 */
typedef NS_ENUM (uint16_t, GlucoseFeatureOption)
{
    /** Flag indicating the support for low battery detection */
    GlucoseFeatureSupportedLowBattery                               = (1 << 0),
    /** Flag indicating the support for sensor malfunction detection */
    GlucoseFeatureSupportedDetectionSensorMalfunction               = (1 << 1),
    /** Flag indicating the support for sensor sample size */
    GlucoseFeatureSupportedSensorSampleSize                         = (1 << 2),
    /** Flag indicating the support for strip insertion error detection */
    GlucoseFeatureSupportedDetectionStripErrorInsertion             = (1 << 3),
    /** Flag indicating the support for strip type error detection */
    GlucoseFeatureSupportedDetectionStripErrorType                  = (1 << 4),
    /** Flag indicating the support for result exceeds sensor limit detection */
    GlucoseFeatureSupportedDetectionResultExceedsSensorLimit        = (1 << 5),
    /** Flag indicating the support for sensor temperature too low or high detection */
    GlucoseFeatureSupportedDetectionSensorTemperatureTooLowHigh     = (1 << 6),
    /** Flag indicating the support for sender read interrupt detection */
    GlucoseFeatureSupportedDetectionSensorReadInterrupt             = (1 << 7),
    /** Flag indicating the support for device fault error */
    GlucoseFeatureSupportedFaultDevice                              = (1 << 8),
    /** Flag indicating the support for time fault error */
    GlucoseFeatureSupportedFaultTime                                = (1 << 9),
    /** Flag indicating the support for multiple bonds */
    GlucoseFeatureSupportedMultipleBonds                            = (1 << 10),
    /** Flag indicating the support for glucose measurement context */
    GlucoseFeatureSupportedGlucoseMeasurementContext                = (1 << 11),
};


///--------------------------------------------------------------
/// @name Special Float Values
///--------------------------------------------------------------
// TODO these should be moved the the UHNBLEController pod to be made available to all specific ble controllers
#define kGlucoseServiceSpecialValuesNaN 0x07FF
#define kGlucoseServiceSpecialValuesNRes 0x0800
#define kGlucoseServiceSpecialValuesPlusInfinity 0x07FE
#define kGlucoseServiceSpecialValuesMinusInfinity 0x0802
