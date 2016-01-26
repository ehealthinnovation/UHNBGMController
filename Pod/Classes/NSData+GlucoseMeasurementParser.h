//
//  NSData+GlucoseMeasurementParser.h
//  UHNBGMController
//
//  Created by Nathaniel Hamming on 2013-05-03.
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
 `NSData+GlucoseMeasurementParser` provides glucose measurement response parsing
 */
@interface NSData (GlucoseMeasurementParser)

/**
 Returns a dictionary with all the data of the glucose measurement characteristic. Keys and enumerations are defined in the `UHNBGMConstants.h` file, which is imported with this category.
 
 @param crcPresent Indicates whether the characteristic includes the E2E-CRC field
 
 @return  All the data of the glucose measurement characteristic as a `NSDictionary`
 
 @discussion Here are the defined keys:
 
    kGlucoseMeasurementKeySequenceNumber:              Sequence number of the glucose measurement and matches the sequnce number of its related glucose measurement context. Stored as a NSNumber
    kGlucoseMeasurementKeyCreationDate:                The creation date of the glucose measurement. Stored as a NSDate
    kGlucoseMeasurementKeyTimeOffset:                  Time offset from the session start time in minutes. Stored as NSNumber.
    kGlucoseMeasurementKeyGlucoseConcentration:        Glucose concentration. Stored as NSNumber.
    kGlucoseMeasurementKeyGlucoseConcentrationUnits:   The unit of the glucose concentration amount. See UHNBGMConstants.h for possible glucose concentration units. Stored as NSNumber
    kGlucoseMeasurementKeyType:                        The fluid type from which the glucose concentration is determined. See UHNBLETypes.h in the UHNBLEController pod for possible fluid type values. Stored as NSNumber
    kGlucoseMeasurementKeySampleLocation:              The sample location from which the glucose concentration is determined. See UHNBLETypes.h in the UHNBLEController pod for possible sample location values. Stored as NSNumber
    kGlucoseMeasurementKeySensorStatusAnnunciation:    The sensor status at the time the glucose measurement was taken. See UHNBGMConstants.h for possible annunciation values. Stored as a NSNumber
    kBGMCRCFailed:                                     Boolean to indicate if the E2E-CRC failed. Only included if CRC is supported. Stored as a NSNumber.
 
 */
- (NSDictionary *) parseGlucoseMeasurementCharacteristicDetails:(BOOL) crcPresent;

@end
