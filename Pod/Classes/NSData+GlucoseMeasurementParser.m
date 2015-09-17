//
//  NSDate+GlucoseMeasurementParser.m
//  UHNBGMController
//
//  Created by Nathaniel Hamming on 2013-05-03.
//  Copyright (c) 2015 University Health Network.

#import "NSData+GlucoseMeasurementParser.h"
#import "NSData+ConversionExtensions.h"
#import "UHNBLETypes.h"
#import "UHNDebug.h"

// TODO this should probably be put in the UHNBLETypes.h file so it can be shared between the NSData+GlucoseMeasurementParser and NSData+CGMParser instead of being redefined
#define kFluidTypeBitMask 0xF

// Glucose Measurement Context Flag Bits
typedef NS_ENUM (NSUInteger, GlucoseMeasurementField)
{
    GlucoseMeasurementFieldTimeOffset           = 1,
    GlucoseMeasurementFieldGlucoseConcentration,
    GlucoseMeasurementFieldGlucoseTypeSampleLocation,
    GlucoseMeasurementFieldSensorStatusAnnunciation,
};

@implementation NSData (GlucoseMeasurementParser)

- (NSDictionary *) parseGlucoseMeasurementCharacteristicDetails:(BOOL) crcPresent;
{
    // TODO: add CRC checking
    
    NSMutableDictionary *measurementDetails = [NSMutableDictionary dictionary];
    
    NSNumber *valueNumber = nil;
    
    // sequence number
    valueNumber = [NSNumber numberWithInteger:[self parseGlucoseMeasurementSequenceNumber]];
    [measurementDetails setObject:valueNumber forKey:kGlucoseMeasurementKeySequenceNumber];
    
    // creation date
    NSDate *creationDate = [self parseDateAtLocation:3 andTimeOffsetInMinutes:[self parseGlucoseMeasurementTimeOffset]];
    [measurementDetails setObject:creationDate forKey:kGlucoseMeasurementKeyCreationDate];
    
    // glucose concentration
    if (nil != (valueNumber = [self parseGlucoseMeasurementGlucoseConcentration]))
    {
        [measurementDetails setObject:valueNumber forKey:kGlucoseMeasurementKeyGlucoseConcentration];
    }
    
    // glucose concentration units
    if (nil != (valueNumber = [self parseGlucoseMeasurementGlucoseConcentrationUnits]))
    {
        [measurementDetails setObject:valueNumber forKey:kGlucoseMeasurementKeyGlucoseConcentrationUnits];
    }

    // type
    if (nil != (valueNumber = [self parseGlucoseMeasurementType]))
    {
        [measurementDetails setObject:valueNumber forKey:kGlucoseMeasurementKeyType];
    }

    // sample location
    if (nil != (valueNumber = [self parseGlucoseMeasurementSampleLocation]))
    {
        [measurementDetails setObject:valueNumber forKey:kGlucoseMeasurementKeySampleLocation];
    }
    
    // sensor status annunciation
    if (nil != (valueNumber = [self parseGlucoseMeasurementSensorStatusAnnunciation]))
    {
        [measurementDetails setObject:valueNumber forKey:kGlucoseMeasurementKeySensorStatusAnnunciation];
    }
    
    return measurementDetails;
}

#pragma mark - Glucose Measurement Parsing Methods

- (NSUInteger) parseGlucoseMeasurementFlags;
{
    return [self unsignedIntegerAtRange:kGlucoseMeasurementRangeFlags];
}

- (NSUInteger) parseGlucoseMeasurementSequenceNumber;
{
    return [self unsignedIntegerAtRange:kGlucoseMeasurementRangeSequenceNumber];
}

- (NSNumber *) parseGlucoseMeasurementTimeOffset;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementFieldDataRange:GlucoseMeasurementFieldTimeOffset];
    
    // check if time offset is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self integerAtRange:dataRange];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementGlucoseConcentration;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementFieldDataRange:GlucoseMeasurementFieldGlucoseConcentration];
    
    // check if glucose concentration is present
    if (dataRange.location != NSNotFound)
    {
        float value = [self shortFloatAtRange:dataRange];
        valueNumber = [NSNumber numberWithFloat:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementGlucoseConcentrationUnits;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementFieldDataRange:GlucoseMeasurementFieldGlucoseConcentration];
    
    // check if glucose concentration units is present
    if (dataRange.location != NSNotFound)
    {
        GlucoseMeasurementGlucoseConcentrationUnits glucoseConcentrationUnits = GlucoseMeasurementGlucoseConcentrationUnitsKgPerL;
        NSUInteger measurementContextFlags = [self parseGlucoseMeasurementFlags];
        
        if (GlucoseMeasurementFlagGlucoseConcentrationUnits & measurementContextFlags)
        {
            glucoseConcentrationUnits = GlucoseMeasurementGlucoseConcentrationUnitsMolPerL;
        }
        
        valueNumber = [NSNumber numberWithUnsignedInteger:(NSUInteger) glucoseConcentrationUnits];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementType;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementFieldDataRange:GlucoseMeasurementFieldGlucoseTypeSampleLocation];
    
    // check if type is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self lowNibbleAtPosition:dataRange.location];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementSampleLocation;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementFieldDataRange:GlucoseMeasurementFieldGlucoseTypeSampleLocation];
    
    // check if sample location is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self highNibbleAtPosition:dataRange.location];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementSensorStatusAnnunciation;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementFieldDataRange:GlucoseMeasurementFieldSensorStatusAnnunciation];
    
    // check if sensor status annunciation is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self unsignedIntegerAtRange:dataRange];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

#pragma mark - Private Methods

- (NSRange) glucoseMeasurementFieldDataRange:(GlucoseMeasurementField) field;
{
    // this method parses data based on the spec found here:
    // https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.glucose_measurement.xml
    
    NSUInteger measurementFlags = [self parseGlucoseMeasurementFlags];
    NSUInteger startPosition = 10;
    NSUInteger sizeOfField = 0;
    NSRange defaultRange = NSMakeRange(NSNotFound, 0);
    GlucoseMeasurementFlagOption flagForField = [self glucoseMeasurementFlagForField:field];
    GlucoseMeasurementField currentField;
    
    // only return a valid range if the flag for the field we want exists in the glucose measurement
    if (flagForField & measurementFlags)
    {
        // now iterate through all the fields of the data until we get to the one we are looking for
        
        // time offset (sint16)
        currentField = GlucoseMeasurementFieldTimeOffset;
        
        if (([self glucoseMeasurementFlagForField:currentField]) & measurementFlags)
        {
            sizeOfField = 2;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // glucose concentration (SFLOAT)
        currentField = GlucoseMeasurementFieldGlucoseConcentration;
        
        if (([self glucoseMeasurementFlagForField:currentField]) & measurementFlags)
        {
            sizeOfField = 2;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // type / sample location (type is first nibble and sample location is second nibble of 8 bit field)
        currentField = GlucoseMeasurementFieldGlucoseTypeSampleLocation;
        
        if (([self glucoseMeasurementFlagForField:currentField]) & measurementFlags)
        {
            sizeOfField = 1;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // sensor status annunciation (16bit)
        currentField = GlucoseMeasurementFieldSensorStatusAnnunciation;
        
        if (([self glucoseMeasurementFlagForField:currentField]) & measurementFlags)
        {
            sizeOfField = 2;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
    }
    
    return defaultRange;
}

// map the glucose context field type to a flag for it in the flags portion of the glucose measurement context data
- (GlucoseMeasurementFlagOption) glucoseMeasurementFlagForField:(GlucoseMeasurementField) field;
{
    GlucoseMeasurementFlagOption option;
    
    switch (field)
    {
        case GlucoseMeasurementFieldTimeOffset:
        {
            option = GlucoseMeasurementFlagPresentTimeOffset;
            break;
        }
        case GlucoseMeasurementFieldGlucoseConcentration:
        case GlucoseMeasurementFieldGlucoseTypeSampleLocation:
        {
            option = GlucoseMeasurementFlagPresentGlucoseConcentrationTypeAndSampleLocation;
            break;
        }
        case GlucoseMeasurementFieldSensorStatusAnnunciation:
        {
            option = GlucoseMeasurementFlagPresentSensorStatusAnnunciation;
            break;
        }
    }
    
    return option;
}

@end
