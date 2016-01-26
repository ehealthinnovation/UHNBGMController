//
//  NSDate+GlucoseMeasurementContextParser.m
//  UHNBGMController
//
//  Created by Adrian de Almeida on 2015-03-26.
//  Copyright (c) 2016 University Health Network.

#import "NSData+GlucoseMeasurementContextParser.h"
#import "NSData+ConversionExtensions.h"
#import "UHNDebug.h"

// Glucose Measurement Context Flag Bits
typedef NS_ENUM (NSUInteger, GlucoseMeasurementContextField)
{
    GlucoseMeasurementContextFieldCarbohydrateID           = 1,
    GlucoseMeasurementContextFieldCarbohydrate,
    GlucoseMeasurementContextFieldMeal,
    GlucoseMeasurementContextFieldTesterHealth,
    GlucoseMeasurementContextFieldExerciseDuration,
    GlucoseMeasurementContextFieldExerciseIntensity,
    GlucoseMeasurementContextFieldMedicationID,
    GlucoseMeasurementContextFieldMedicationValue,
    GlucoseMeasurementContextFieldHbA1c,
    GlucoseMeasurementContextFieldExtendedFlags,
};

@implementation NSData (GlucoseMeasurementContextParser)

- (NSDictionary *) parseGlucoseMeasurementContextCharacteristicDetails:(BOOL) crcPresent;
{
    // TODO: add CRC checking
    
    NSMutableDictionary *measurementContextDetails = [NSMutableDictionary dictionary];
    
    NSNumber *valueNumber = nil;

    // sequence number
    valueNumber = [NSNumber numberWithInteger:[self parseGlucoseMeasurementContextSequenceNumber]];
    [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeySequenceNumber];
    
    // extended flags
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextExtendedFlags]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyExtendedFlags];
    }
    
    // carbohydrateID
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextCarbohydrateID]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyCarbohydrateID];
    }
    
    // carbohydrate
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextCarbohydrate]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyCarbohydrate];
    }

    // meal
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextMeal]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyMeal];
    }
    
    // tester
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextTester]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyTester];
    }
    
    // health
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextHealth]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyHealth];
    }
    
    // exercise duration
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextExerciseDuration]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyExerciseDuration];
    }
    
    // exercise intensity
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextExerciseIntensity]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyExerciseIntensity];
    }
    
    // medication ID
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextMedicationID]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyMedicationID];
    }
    
    // medication value
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextMedicationValue]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyMedicationValue];
    }
    
    // medication units
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextMedicationUnits]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyMedicationUnits];
    }
    
    // hba1c
    if (nil != (valueNumber = [self parseGlucoseMeasurementContextHbA1c]))
    {
        [measurementContextDetails setObject:valueNumber forKey:kGlucoseMeasurementContextKeyHbA1c];
    }
    
    return measurementContextDetails;
}

#pragma mark Glucose Measurement Context Parsing Methods

- (NSUInteger) parseGlucoseMeasurementContextFlags;
{
    return [self unsignedIntegerAtRange:kGlucoseMeasurementContextRangeFlags];
}

- (NSUInteger) parseGlucoseMeasurementContextSequenceNumber;
{
    return (NSUInteger)[self unsignedIntegerAtRange:kGlucoseMeasurementContextRangeSequenceNumber];
}

- (NSNumber *) parseGlucoseMeasurementContextExtendedFlags;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldExtendedFlags];
    
    // check if extended flags is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self unsignedIntegerAtRange:dataRange];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextCarbohydrateID;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldCarbohydrateID];

    // check if carbohydrate ID is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self unsignedIntegerAtRange:dataRange];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }

    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextCarbohydrate;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldCarbohydrate];
    
    // check if carbohydrate is present
    if (dataRange.location != NSNotFound)
    {
        float value = [self shortFloatAtRange:dataRange];
        valueNumber = [NSNumber numberWithFloat:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextMeal;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldMeal];
    
    // check if meal is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self unsignedIntegerAtRange:dataRange];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextTester;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldTesterHealth];
    
    // check if tester is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self lowNibbleAtPosition:dataRange.location];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextHealth;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldTesterHealth];
    
    // check if health is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self highNibbleAtPosition:dataRange.location];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextExerciseDuration;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldExerciseDuration];
    
    // check if exercise duration is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self unsignedIntegerAtRange:dataRange];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextExerciseIntensity;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldExerciseIntensity];
    
    // check if exercise intensity is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self unsignedIntegerAtRange:dataRange];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextMedicationID;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldMedicationID];
    
    // check if medication ID is present
    if (dataRange.location != NSNotFound)
    {
        NSUInteger value = [self unsignedIntegerAtRange:dataRange];
        valueNumber = [NSNumber numberWithUnsignedInteger:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextMedicationValue;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldMedicationValue];
    
    // check if medication value is present
    if (dataRange.location != NSNotFound)
    {
        float value = [self shortFloatAtRange:dataRange];
        valueNumber = [NSNumber numberWithFloat:value];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextMedicationUnits;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldMedicationValue];
    
    // check if medication units is present
    if (dataRange.location != NSNotFound)
    {
        GlucoseMeasurementContextMedicationUnits medicationUnits = GlucoseMeasurementContextMedicationUnitsKg;
        NSUInteger measurementContextFlags = [self parseGlucoseMeasurementContextFlags];

        if (GlucoseMeasurementContextFlagPresentMedicationUnits & measurementContextFlags)
        {
            medicationUnits = GlucoseMeasurementContextMedicationUnitsL;
        }
        
        valueNumber = [NSNumber numberWithUnsignedInteger:(NSUInteger) medicationUnits];
    }
    
    return valueNumber;
}

- (NSNumber *) parseGlucoseMeasurementContextHbA1c;
{
    NSNumber *valueNumber = nil;
    NSRange dataRange = [self glucoseMeasurementContextFieldDataRange:GlucoseMeasurementContextFieldHbA1c];
    
    // check if hba1c is present
    if (dataRange.location != NSNotFound)
    {
        float value = [self shortFloatAtRange:dataRange];
        valueNumber = [NSNumber numberWithFloat:value];
    }
    
    return valueNumber;
}

#pragma mark - Private Methods

- (NSRange) glucoseMeasurementContextFieldDataRange:(GlucoseMeasurementContextField) field;
{
    // this method parses data based on the spec found here:
    // https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicViewer.aspx?u=org.bluetooth.characteristic.glucose_measurement_context.xml
    
    NSUInteger measurementContextFlags = [self parseGlucoseMeasurementContextFlags];
    NSUInteger startPosition = 3;
    NSUInteger sizeOfField = 0;
    NSRange defaultRange = NSMakeRange(NSNotFound, 0);
    GlucoseMeasurementContextFlagOption flagForField = [self glucoseMeasurementContextFlagForField:field];
    GlucoseMeasurementContextField currentField;

    // only return a valid range if the flag for the field we want exists in the glucose measurement context
    if (flagForField & measurementContextFlags)
    {
        // now iterate through all the fields of the data until we get to the one we are looking for
        
        // extended flags (8 bit)
        currentField = GlucoseMeasurementContextFieldExtendedFlags;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
        {
            sizeOfField = 1;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
    
        // carbohydrateID (uint8)
        currentField = GlucoseMeasurementContextFieldCarbohydrateID;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
        {
            sizeOfField = 1;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // carbohydrate (SFLOAT)
        currentField = GlucoseMeasurementContextFieldCarbohydrate;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
        {
            sizeOfField = 2;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // meal (uint8)
        currentField = GlucoseMeasurementContextFieldMeal;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
        {
            sizeOfField = 1;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // tester / health (tester is first nibble and health is second nibble of 8 bit field)
        currentField = GlucoseMeasurementContextFieldTesterHealth;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
        {
            sizeOfField = 1;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // exercise duration (uint16)
        currentField = GlucoseMeasurementContextFieldExerciseDuration;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
        {
            sizeOfField = 2;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // exercise intensity (uint8)
        currentField = GlucoseMeasurementContextFieldExerciseIntensity;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
        {
            sizeOfField = 1;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // medication ID (uint8)
        currentField = GlucoseMeasurementContextFieldMedicationID;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
        {
            sizeOfField = 1;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // medication (SFLOAT)
        currentField = GlucoseMeasurementContextFieldMedicationValue;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
        {
            sizeOfField = 2;
            
            if (field == currentField)
            {
                return NSMakeRange(startPosition, sizeOfField);
            }
            
            startPosition += sizeOfField;
        }
        
        // HbA1c (SFLOAT)
        currentField = GlucoseMeasurementContextFieldHbA1c;
        
        if (([self glucoseMeasurementContextFlagForField:currentField]) & measurementContextFlags)
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
- (GlucoseMeasurementContextFlagOption) glucoseMeasurementContextFlagForField:(GlucoseMeasurementContextField) field;
{
    GlucoseMeasurementContextFlagOption option;
    
    switch (field)
    {
        case GlucoseMeasurementContextFieldCarbohydrateID:
        case GlucoseMeasurementContextFieldCarbohydrate:
        {
            option = GlucoseMeasurementContextFlagPresentCarbohydrateIDAndCarbohydrate;
            break;
        }
        case GlucoseMeasurementContextFieldMeal:
        {
            option = GlucoseMeasurementContextFlagPresentMeal;
            break;
        }
        case GlucoseMeasurementContextFieldTesterHealth:
        {
            option = GlucoseMeasurementContextFlagPresentTesterHealth;
            break;
        }
        case GlucoseMeasurementContextFieldExerciseDuration:
        case GlucoseMeasurementContextFieldExerciseIntensity:
        {
            option = GlucoseMeasurementContextFlagPresentExerciseDurationAndExerciseIntensity;
            break;
        }
        case GlucoseMeasurementContextFieldMedicationID:
        case GlucoseMeasurementContextFieldMedicationValue:
        {
            option = GlucoseMeasurementContextFlagPresentMedicationIDAndMedication;
            break;
        }
        case GlucoseMeasurementContextFieldHbA1c:
        {
            option = GlucoseMeasurementContextFlagPresentHbA1c;
            break;
        }
        case GlucoseMeasurementContextFieldExtendedFlags:
        {
            option = GlucoseMeasurementContextFlagPresentExtendedFlags;
            break;
        }
    }
    
    return option;
}

@end
