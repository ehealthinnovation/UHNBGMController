//
//  NSDate+BGMParser.m
//  UHNBGMController
//
//  Created by Nathaniel Hamming on 2013-05-03.
//  Copyright (c) 2015 University Health Network.

#import "NSData+BGMParser.h"
#import "NSData+ConversionExtensions.h"
#import "UHNDebug.h"

// TODO this should probably be put in the UHNBLETypes.h file so it can be shared between the NSData+BGMParser and NSData+CGMParser instead of being redefined
#define kFluidTypeBitMask 0xF

@implementation NSData (BGMParser)

- (NSDictionary*)parseGlucoseMeasurementCharacteristicDetails;
{
    //TODO construct a dictionary with all the measurement details
    return nil;
}

- (NSUInteger)parseGlucoseMeasurementFlags;
{
    // TODO move the byte ranges to the UHNBGMConstants (see UHNRACPConstants.h)
    return [self unsignedIntegerAtRange: NSMakeRange(0, 1)];
}

- (NSUInteger)parseGlucoseMeasurementSequenceNumber;
{
    // TODO move the byte ranges to the UHNBGMConstants (see UHNRACPConstants.h)
    return [self unsignedIntegerAtRange: NSMakeRange(1, 2)];
}

- (NSInteger)parseGlucoseMeasurementTimeOffset;
{
    NSInteger timeOffset = 0;
    NSUInteger measurementFlags = [self parseGlucoseMeasurementFlags];
    if (measurementFlags & GlucoseMeasurementFlagPresentTimeOffset) {
        // TODO move the byte ranges to the UHNBGMConstants (see UHNRACPConstants.h)
        timeOffset = [self integerAtRange: NSMakeRange(10, 2)];
    }
    return timeOffset;
}

- (NSDate*)parseGlucoseMeasurementCreationDate;
{
    // TODO this conversion is already implemented in the UHNCGMController pod. Move the conversion to UHNBLEController pod
    // TODO move the byte ranges to the UHNBGMConstants (see UHNRACPConstants.h)
    NSUInteger year = [self unsignedIntegerAtRange: NSMakeRange(3, 2)];
    NSUInteger month = [self unsignedIntegerAtRange: NSMakeRange(5, 1)];
    NSUInteger day = [self unsignedIntegerAtRange: NSMakeRange(6, 1)];
    NSUInteger hours = [self unsignedIntegerAtRange: NSMakeRange(7, 1)];
    NSUInteger minutes = [self unsignedIntegerAtRange: NSMakeRange(8, 1)];
    NSUInteger seconds = [self unsignedIntegerAtRange: NSMakeRange(9, 1)];
    
    NSInteger timeOffset = [self parseGlucoseMeasurementTimeOffset];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setCalendar:calendar];
    [components setYear: year];
    [components setMonth: month];
    [components setDay: day];
    [components setHour: hours];
    [components setMinute: minutes + timeOffset];
    [components setSecond: seconds];
    NSDate *creationDate = [calendar dateFromComponents:components];

    return creationDate;
}

- (NSNumber*)parseGlucoseMeasurementConcentration;
{
    NSNumber *concentration = nil;
    NSUInteger measurementFlags = [self parseGlucoseMeasurementFlags];
    if ((measurementFlags & GlucoseMeasurementFlagPresentTypeLocation) && (measurementFlags & GlucoseMeasurementFlagPresentTimeOffset)) {
        // TODO move the byte ranges to the UHNBGMConstants (see UHNRACPConstants.h)
        float concentrationAsFloat = [self shortFloatAtRange:(NSRange){12, 2}];
        concentration = [NSNumber numberWithFloat: concentrationAsFloat];
    } else {
        // TODO move the byte ranges to the UHNBGMConstants (see UHNRACPConstants.h)
        float concentrationAsFloat = [self shortFloatAtRange:(NSRange){10, 2}];
        concentration = [NSNumber numberWithFloat: concentrationAsFloat];
    }
    return concentration;
}

- (NSUInteger)parseGlucoseMeasurementTypeAndSampleLocation;
{
    NSUInteger measurementFlags = [self parseGlucoseMeasurementFlags];
    if ((measurementFlags & GlucoseMeasurementFlagPresentTypeLocation) && (measurementFlags & GlucoseMeasurementFlagPresentTimeOffset)) {
        return [self unsignedIntegerAtRange: (NSRange){14, 1}];
    } else {
        return [self unsignedIntegerAtRange: (NSRange){12, 1}];
    }
}

//TODO this method alread exists in the UHNCGMController pod. Try to reuse
- (NSUInteger)parseGlucoseMeasurementType;
{
    NSUInteger typeAndLocation = [self parseGlucoseMeasurementTypeAndSampleLocation];

    // Remove location using bit mask
    NSUInteger type = typeAndLocation & kFluidTypeBitMask;

    return type;
}

//TODO this method alread exists in the UHNCGMController pod. Try to reuse
- (NSUInteger)parseGlucoseMeasurementSampleLocation;
{
    NSUInteger typeAndLocation = [self parseGlucoseMeasurementTypeAndSampleLocation];
    
    // Remove type using bit shifting
    NSUInteger sampleLocation = typeAndLocation >> 4;
    
    return sampleLocation;
}

- (NSUInteger)parseGlucoseMeasurementSensorStatus;
{
    NSUInteger measurementFlags = [self parseGlucoseMeasurementFlags];
    if ((measurementFlags & GlucoseMeasurementFlagPresentTypeLocation) && (measurementFlags & GlucoseMeasurementFlagPresentTimeOffset)) {
        return [self unsignedIntegerAtRange: (NSRange){15, 2}];
    } else {
        return [self unsignedIntegerAtRange: (NSRange){13, 2}];
    }
}

- (NSUInteger)parseGlucoseMeasurementUnitsFormat;
{
    NSUInteger unitsFormat = 0;
    NSUInteger measurementFlags = [self parseGlucoseMeasurementFlags];
    if (measurementFlags & GlucoseMeasurementFlagUnitsFormat) {
        unitsFormat = 1;
    }
    
    return unitsFormat;
}

@end
