//
//  UHNBGMConstants.h
//  UHNBGMController
//
//  Created by kevin on 2013-01-08.
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


// Glucose UUIDs can be found here: http://developer.bluetooth.org/gatt/profiles/Pages/ProfileViewer.aspx?u=org.bluetooth.profile.glucose.xml

// Service UUID
#define kGlucoseServiceUUID @"1808"

// Characteristic UUID
#define kGlucoseCharacteristicUUIDMeasurement @"2A18"
#define kGlucoseCharacteristicUUIDMeasurementContext @"2A34"
#define kGlucoseCharacteristicUUIDSupportedFeatures @"2A51"
#define kGlucoseCharacteristicUUIDRACP @"2A52"

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

// Glucose Measurement Flag Bits
typedef NS_ENUM (uint8_t, GlucoseMeasurementFlagOption) {
    GlucoseMeasurementFlagPresentTimeOffset         = (1 << 0),
    GlucoseMeasurementFlagPresentTypeLocation       = (1 << 1),
    GlucoseMeasurementFlagUnitsFormat               = (1 << 2), // 0 = kg/L, 1 = mol/L
    GlucoseMeasurementFlagPresentStatus             = (1 << 3),
    GlucoseMeasurementFlagPresentContextInfo        = (1 << 4)
};

// Glucose Measurement Fluid Type
/** Fluid Type is defined in the UHNBLETypes.h constants in the UHNBLEController pod */

// Glucose Measurement Sample Location
/** Sample location is defined in the UHNBLETypes.h constants in the UHNBLEController pod */

// Glucose Measurement Sensor Status Bits
typedef NS_ENUM (uint16_t, GlucoseMeasurementStatusOption) {
    GlucoseMeasurementStatusDeviceBatteryLow                = (1 << 0),
    GlucoseMeasurementStatusSensorMalfunction               = (1 << 1),
    GlucoseMeasurementStatusSampleSizeInsufficient          = (1 << 2),
    GlucoseMeasurementStatusStripInsertionError             = (1 << 3),
    GlucoseMeasurementStatusStripTypeIncorrect              = (1 << 4),
    GlucoseMeasurementStatusResultExceedsSensorLimitUpper   = (1 << 5),
    GlucoseMeasurementStatusResultExceedsSensorLimitLower   = (1 << 6),
    GlucoseMeasurementStatusDeviceTemperatureTooHigh        = (1 << 7),
    GlucoseMeasurementStatusDeviceTemperatureTooLow         = (1 << 8),
    GlucoseMeasurementStatusStripPulledTooSoon              = (1 << 9),
    GlucoseMeasurementStatusFaultGeneral                    = (1 << 10),
    GlucoseMeasurementStatusFaultTime                       = (1 << 11)
};


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


// TODO add Glucose Measurement Context


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

// Feature Support Bits
typedef NS_ENUM (uint16_t, GlucoseFeatureOption) {
    GlucoseFeatureSupportedLowBattery                               = (1 << 0),
    GlucoseFeatureSupportedDetectionSensorMalfunction               = (1 << 1),
    GlucoseFeatureSupportedSensorSampleSize                         = (1 << 2),
    GlucoseFeatureSupportedDetectionStripErrorInsertion             = (1 << 3),
    GlucoseFeatureSupportedDetectionStripErrorType                  = (1 << 4),
    GlucoseFeatureSupportedDetectionResultExceedsSensorLimit        = (1 << 5),
    GlucoseFeatureSupportedDetectionSensorTemperatureTooLowHigh     = (1 << 6),
    GlucoseFeatureSupportedDetectionSensorReadInterrupt             = (1 << 7),
    GlucoseFeatureSupportedFaultDevice                              = (1 << 8),
    GlucoseFeatureSupportedFaultTime                                = (1 << 9),
    GlucoseFeatureSupportedMultipleBonds                            = (1 << 10),
};


// Error codes
#define kGlucoseServiceErrorCodeProcedureInProgress 0x80
#define kGlucoseServiceErrorCodeClientCharacteristicConfigDescriptorImproperlyConfigured 0x81

// Special Float Values
// TODO these should be moved the the UHNBLEController pod to be made available to all specific ble controllers
#define kGlucoseServiceSpecialValuesNaN 0x07FF
#define kGlucoseServiceSpecialValuesNRes 0x0800
#define kGlucoseServiceSpecialValuesPlusInfinity 0x07FE
#define kGlucoseServiceSpecialValuesMinusInfinity 0x0802


// TODO Ensure that the RACP in the UHNBLEController pod allows for all applicable procedures. Update as needed
