//
//  UHNBGMParserTests.m
//  UHNBGMControllerTests
//
//  Created by Nathaniel Hamming on 2016-01-22.
//  Copyright © 2016 Nathaniel Hamming. All rights reserved.
//

#import <UHNBGMController/NSData+GlucoseMeasurementContextParser.h>
#import <UHNBGMController/NSData+GlucoseMeasurementParser.h>
#import <UHNBLEController/UHNBLETypes.h>

SpecBegin(BGMParserSpecs)

describe(@"Glucose measurement characteristic response parsing", ^{
    it(@"should parse a measurement with basic information", ^{
        
        uint8_t size = 13;
        uint8_t flag = 0x06; // Glucose Concentration, Type and Sample Location Present, Mol/L
        uint16_t sequenceNumber = 0x000A;
        
        // get the actual values for a time of now.
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSUInteger const kComponentBits = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                           | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone);
        NSDateComponents *components = [cal components:kComponentBits fromDate: [NSDate date]];
        uint16_t year = components.year;
        uint8_t month = components.month;
        uint8_t day = components.day;
        uint8_t hour = components.hour;
        uint8_t minute = components.minute;
        uint8_t second = components.second;
        NSDate *date = [cal dateFromComponents:components];
        
        uint16_t glucoseConcentration = 140;
        GlucoseMeasurementGlucoseConcentrationUnits glucoseUnits = GlucoseMeasurementGlucoseConcentrationUnitsMolPerL;

        GlucoseFluidTypeOption type = GlucoseFluidTypeISF;
        GlucoseSampleLocationOption location = GlucoseSampleLocationSubcutaneousTissue;
        uint8_t jointValue = type | (location << 4);

        NSData *measurementData = [NSData dataWithBytes:(char[]){flag, sequenceNumber, (sequenceNumber >> 8), year, (year >> 8), month, day, hour, minute, second, glucoseConcentration, (glucoseConcentration >> 8), jointValue} length:size];
        NSDictionary *measurementDetails = [measurementData parseGlucoseMeasurementCharacteristicDetails:NO];

        // confirm the measurement data
        expect(measurementDetails[kGlucoseMeasurementKeySequenceNumber]).to.equal(sequenceNumber);
        expect(measurementDetails[kGlucoseMeasurementKeyCreationDate]).to.equal(date);
        expect(measurementDetails[kGlucoseMeasurementKeyGlucoseConcentration]).to.equal(glucoseConcentration);
        expect(measurementDetails[kGlucoseMeasurementKeyGlucoseConcentrationUnits]).to.equal(glucoseUnits);
        expect(measurementDetails[kGlucoseMeasurementKeyType]).to.equal(type);
        expect(measurementDetails[kGlucoseMeasurementKeySampleLocation]).to.equal(location);
    });
    
    it(@"should parse a measurement with time offset", ^{
        uint8_t size = 15;
        uint8_t flag = 0x03; // Time Offset Present, Glucose Concentration, Type and Sample Location Present, Kg/L
        uint16_t sequenceNumber = 0x000B;
        
        // get the actual values for a time of now.
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSUInteger const kComponentBits = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                           | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone);
        NSDateComponents *components = [cal components:kComponentBits fromDate: [NSDate date]];
        uint16_t year = components.year;
        uint8_t month = components.month;
        uint8_t day = components.day;
        uint8_t hour = components.hour;
        uint8_t minute = components.minute;
        uint8_t second = components.second;
        int16_t timeOffset = 5;
        NSDate *date = [[cal dateFromComponents:components] dateByAddingTimeInterval:5*60.];
        
        uint16_t glucoseConcentration = 140;
        GlucoseMeasurementGlucoseConcentrationUnits glucoseUnits = GlucoseMeasurementGlucoseConcentrationUnitsKgPerL;
        
        GlucoseFluidTypeOption type = GlucoseFluidTypeISF;
        GlucoseSampleLocationOption location = GlucoseSampleLocationSubcutaneousTissue;
        uint8_t jointValue = type | (location << 4);
        
        NSData *measurementData = [NSData dataWithBytes:(char[]){flag, sequenceNumber, (sequenceNumber >> 8), year, (year >> 8), month, day, hour, minute, second, timeOffset, (timeOffset >> 8), glucoseConcentration, (glucoseConcentration >> 8), jointValue} length:size];
        NSDictionary *measurementDetails = [measurementData parseGlucoseMeasurementCharacteristicDetails:NO];
        
        // confirm the measurement data
        expect(measurementDetails[kGlucoseMeasurementKeySequenceNumber]).to.equal(sequenceNumber);
        expect(measurementDetails[kGlucoseMeasurementKeyCreationDate]).to.equal(date);
        expect(measurementDetails[kGlucoseMeasurementKeyGlucoseConcentration]).to.equal(glucoseConcentration);
        expect(measurementDetails[kGlucoseMeasurementKeyGlucoseConcentrationUnits]).to.equal(glucoseUnits);
        expect(measurementDetails[kGlucoseMeasurementKeyType]).to.equal(type);
        expect(measurementDetails[kGlucoseMeasurementKeySampleLocation]).to.equal(location);
    });

    it(@"should parse a measurement with status annunciation", ^{
        uint8_t size = 15;
        uint8_t flag = 0x0E; // Glucose Concentration, Type and Sample Location Present, Mol/L, status present
        uint16_t sequenceNumber = 0x000C;
        uint16_t status = 0x0485; // battery low, sample size insufficient, temp too high, general fault

        // get the actual values for a time of now.
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSUInteger const kComponentBits = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                           | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone);
        NSDateComponents *components = [cal components:kComponentBits fromDate: [NSDate date]];
        uint16_t year = components.year;
        uint8_t month = components.month;
        uint8_t day = components.day;
        uint8_t hour = components.hour;
        uint8_t minute = components.minute;
        uint8_t second = components.second;
        NSDate *date = [cal dateFromComponents:components];
        
        uint16_t glucoseConcentration = 140;
        GlucoseMeasurementGlucoseConcentrationUnits glucoseUnits = GlucoseMeasurementGlucoseConcentrationUnitsMolPerL;
        
        GlucoseFluidTypeOption type = GlucoseFluidTypeISF;
        GlucoseSampleLocationOption location = GlucoseSampleLocationSubcutaneousTissue;
        uint8_t jointValue = type | (location << 4);
        
        NSData *measurementData = [NSData dataWithBytes:(char[]){flag, sequenceNumber, (sequenceNumber >> 8), year, (year >> 8), month, day, hour, minute, second, glucoseConcentration, (glucoseConcentration >> 8), jointValue, status, (status >> 8)} length:size];
        NSDictionary *measurementDetails = [measurementData parseGlucoseMeasurementCharacteristicDetails:NO];
        
        // confirm the measurement data
        expect(measurementDetails[kGlucoseMeasurementKeySequenceNumber]).to.equal(sequenceNumber);
        expect(measurementDetails[kGlucoseMeasurementKeyCreationDate]).to.equal(date);
        expect(measurementDetails[kGlucoseMeasurementKeyGlucoseConcentration]).to.equal(glucoseConcentration);
        expect(measurementDetails[kGlucoseMeasurementKeyGlucoseConcentrationUnits]).to.equal(glucoseUnits);
        expect(measurementDetails[kGlucoseMeasurementKeyType]).to.equal(type);
        expect(measurementDetails[kGlucoseMeasurementKeySampleLocation]).to.equal(location);
        expect(measurementDetails[kGlucoseMeasurementKeySensorStatusAnnunciation]).to.equal(status);
    });
});

describe(@"Glucose measurement context characteristic response parsing", ^{
    it(@"should parse Glucose measurement context with basic information", ^{
        uint8_t size = 7;
        uint8_t flag = 0x03; // carb ID and carbs present, meal present
        uint16_t sequenceNumber = 0x000D;
        
        GlucoseMeasurementContextCarbohydrateID carbID = GlucoseMeasurementContextCarbohydrateIDBreakfast;
        uint16_t carbs = 90;

        GlucoseMeasurementContextMeal mealID = GlucoseMeasurementContextMealPostprandial;
        
        NSData *contextData = [NSData dataWithBytes:(char[]){flag, sequenceNumber, (sequenceNumber >> 8), carbID, carbs, (carbs >> 8), mealID} length:size];
        NSDictionary *contextDetails = [contextData parseGlucoseMeasurementContextCharacteristicDetails:NO];
        expect(contextDetails[kGlucoseMeasurementContextKeySequenceNumber]).to.equal(sequenceNumber);
        expect(contextDetails[kGlucoseMeasurementContextKeyCarbohydrateID]).to.equal(carbID);
        expect(contextDetails[kGlucoseMeasurementContextKeyCarbohydrate]).to.equal(carbs);
        expect(contextDetails[kGlucoseMeasurementContextKeyMeal]).to.equal(mealID);
    });

    it(@"should parse Glucose measurement context with more information", ^{
        uint8_t size = 11;
        uint8_t flag = 0x0F; // carb ID and carbs present, meal present, tester-health present, exercise duration and intensity present
        uint16_t sequenceNumber = 0x000E;
        
        GlucoseMeasurementContextCarbohydrateID carbID = GlucoseMeasurementContextCarbohydrateIDBreakfast;
        uint16_t carbs = 90;
        
        GlucoseMeasurementContextMeal mealID = GlucoseMeasurementContextMealPostprandial;
        GlucoseMeasurementContextTester testerID = GlucoseMeasurementContextTesterHealthCareProfessional;
        GlucoseMeasurementContextHealth healthID = GlucoseMeasurementContextHealthUnderStress;
        uint8_t jointValue = testerID | (healthID << 4);
        
        uint16_t exerciseDuration = 30 * 60;
        uint8_t exercisePercentage = 75;
        
        NSData *contextData = [NSData dataWithBytes:(char[]){flag, sequenceNumber, (sequenceNumber >> 8), carbID, carbs, (carbs >> 8), mealID, jointValue, exerciseDuration, (exerciseDuration >> 8), exercisePercentage} length:size];
        NSDictionary *contextDetails = [contextData parseGlucoseMeasurementContextCharacteristicDetails:NO];
        expect(contextDetails[kGlucoseMeasurementContextKeySequenceNumber]).to.equal(sequenceNumber);
        expect(contextDetails[kGlucoseMeasurementContextKeyCarbohydrateID]).to.equal(carbID);
        expect(contextDetails[kGlucoseMeasurementContextKeyCarbohydrate]).to.equal(carbs);
        expect(contextDetails[kGlucoseMeasurementContextKeyMeal]).to.equal(mealID);
        expect(contextDetails[kGlucoseMeasurementContextKeyTester]).to.equal(testerID);
        expect(contextDetails[kGlucoseMeasurementContextKeyHealth]).to.equal(healthID);
        expect(contextDetails[kGlucoseMeasurementContextKeyExerciseDuration]).to.equal(exerciseDuration);
        expect(contextDetails[kGlucoseMeasurementContextKeyExerciseIntensity]).to.equal(exercisePercentage);
    });
    
    it(@"should parse Glucose measurement context with lots of information", ^{
        uint8_t size = 16;
        uint8_t flag = 0x5F; // carb ID and carbs present, meal present, tester-health present, exercise duration and intensity present, med ID and med present, med units = Kg, HbA1c present
        uint16_t sequenceNumber = 0x000F;
        
        GlucoseMeasurementContextCarbohydrateID carbID = GlucoseMeasurementContextCarbohydrateIDBreakfast;
        uint16_t carbs = 90;
        
        GlucoseMeasurementContextMeal mealID = GlucoseMeasurementContextMealPostprandial;
        GlucoseMeasurementContextTester testerID = GlucoseMeasurementContextTesterHealthCareProfessional;
        GlucoseMeasurementContextHealth healthID = GlucoseMeasurementContextHealthUnderStress;
        uint8_t jointValue = testerID | (healthID << 4);
        
        GlucoseMeasurementContextMedicationID medID = GlucoseMeasurementContextMedicationIDShortActingInsulin;
        GlucoseMeasurementContextMedicationUnits medUnits = GlucoseMeasurementContextMedicationUnitsKg;
        
        uint16_t exerciseDuration = 30 * 60;
        uint8_t exercisePercentage = 75;
        uint16_t meds = 15;
        uint16_t HbA1c = 6;
        
        NSData *contextData = [NSData dataWithBytes:(char[]){flag, sequenceNumber, (sequenceNumber >> 8), carbID, carbs, (carbs >> 8), mealID, jointValue, exerciseDuration, (exerciseDuration >> 8), exercisePercentage, medID, meds, (meds >> 8), HbA1c, (HbA1c >> 8)} length:size];
        NSDictionary *contextDetails = [contextData parseGlucoseMeasurementContextCharacteristicDetails:NO];
        expect(contextDetails[kGlucoseMeasurementContextKeySequenceNumber]).to.equal(sequenceNumber);
        expect(contextDetails[kGlucoseMeasurementContextKeyCarbohydrateID]).to.equal(carbID);
        expect(contextDetails[kGlucoseMeasurementContextKeyCarbohydrate]).to.equal(carbs);
        expect(contextDetails[kGlucoseMeasurementContextKeyMeal]).to.equal(mealID);
        expect(contextDetails[kGlucoseMeasurementContextKeyTester]).to.equal(testerID);
        expect(contextDetails[kGlucoseMeasurementContextKeyHealth]).to.equal(healthID);
        expect(contextDetails[kGlucoseMeasurementContextKeyExerciseDuration]).to.equal(exerciseDuration);
        expect(contextDetails[kGlucoseMeasurementContextKeyExerciseIntensity]).to.equal(exercisePercentage);
        expect(contextDetails[kGlucoseMeasurementContextKeyMedicationID]).to.equal(medID);
        expect(contextDetails[kGlucoseMeasurementContextKeyMedicationValue]).to.equal(meds);
        expect(contextDetails[kGlucoseMeasurementContextKeyMedicationUnits]).to.equal(medUnits);
        expect(contextDetails[kGlucoseMeasurementContextKeyHbA1c]).to.equal(HbA1c);
    });
});

SpecEnd
