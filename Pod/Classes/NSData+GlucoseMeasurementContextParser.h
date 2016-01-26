//
//  NSData+GlucoseMeasurementContextParser.h
//  UHNBGMController
//
//  Created by Adrian de Almeida on 2015-03-24.
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
#import "UHNBGMConstants.h"

/**
 `NSData+GlucoseMeasurementContextParser` provides glucose measurement context response parsing
 */
@interface NSData (GlucoseMeasurementContextParser)

/**
 Returns a dictionary with all the data of the glucose measurement context characteristic. Keys and enumerations are defined in the `UHNBGMConstants.h` file, which is imported with this category.
 
 @param crcPresent Indicates whether the characteristic includes the E2E-CRC field
 
 @return  All the data of the glucose measurement context characteristic as a `NSDictionary`
 
 @discussion Here are the defined keys:
 
    kGlucoseMeasurementContextKeySequenceNumber:        Sequence number of the glucose measurement context and matches the sequnce number of its related glucose measurement. Stored as a NSNumber
    kGlucoseMeasurementContextKeyExtendedFlags:         The extended flags are currently reserved for future use. Stored as a NSNumber
    kGlucoseMeasurementContextKeyCarbohydrateID:        The context of the associated carbohydrate value. See UHNBGMConstants.h for possible ID values. Stored as a NSNumber
    kGlucoseMeasurementContextKeyCarbohydrate:          The value of the carbohydrate. Unit is kilogram. Stored as a NSNumber
    kGlucoseMeasurementContextKeyMeal:                  The meal context of the glucose measurement. See UHNBGMConstants.h for possible meal values. Stored as a NSNumber
    kGlucoseMeasurementContextKeyTester:                The tester context of the glucose measurement. See UHNBGMConstants.h for possible tester values. Stored as a NSNumber
    kGlucoseMeasurementContextKeyHealth:                The health context of the glucose measurement. See UHNBGMConstants.h for possible health values. Stored as a NSNumber
    kGlucoseMeasurementContextKeyExerciseDuration:      The value of the exercise duration. Unit is second. Stored as a NSNumber
    kGlucoseMeasurementContextKeyExerciseIntensity:     The value of the exercise percentage. Unit is percentage. Stored as a NSNumber
    kGlucoseMeasurementContextKeyMedicationID:          The medication context of the glucose measurement. See UHNBGMConstants.h for possible medication values. Stored as a NSNumber
    kGlucoseMeasurementContextKeyMedicationValue:       The value of the medication amount. Stored as a NSNumber
    kGlucoseMeasurementContextKeyMedicationUnits:       The unit of the medication amount. See UHNBGMConstants.h for possible medication units. Stored as a NSNumber
    kGlucoseMeasurementContextKeyHbA1c:                 The value of the HbA1c. Unit is percentage. Stored as a NSNumber
 
 */
- (NSDictionary *) parseGlucoseMeasurementContextCharacteristicDetails:(BOOL) crcPresent;

@end
