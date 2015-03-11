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
#import "UHNBGMConstants.h"
#import "UHNRACPConstants.h"

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

///----------------------------------
/// @name Record Access Control Point
///----------------------------------
- (void)getNumberOfRecords;
- (void)getAllRecords;

@end


@protocol UHNBGMControllerDelegate <NSObject>
- (void)bgmController:(UHNBGMController*)controller didDiscoverGlucoseMeterWithName:(NSString*)bgmDeviceName services:(NSArray*)serviceUUIDs RSSI:(NSNumber*)RSSI;
- (void)bgmController:(UHNBGMController*)controller didConnectToGlucoseMeterWithName:(NSString*)bgmDeviceName;
- (void)bgmController:(UHNBGMController*)controller didDisconnectFromGlucoseMeter:(NSString*)bgmDeviceName;

- (void)bgmController:(UHNBGMController*)controller didGetNumberOfRecords:(NSUInteger)numberOfRecords;
- (void)bgmController:(UHNBGMController*)controller didGetRecordWithValue:(NSNumber*)value creationDate:(NSDate*)date unitsFormat:(NSUInteger)unitsFormat atIndex:(NSUInteger)index;
- (void)bgmController:(UHNBGMController*)controller didCompleteTransferWithNumberOfRecords:(NSUInteger)numberOfRecords;

@optional
- (void)bgmController:(UHNBGMController*)controller RACPOperationSuccessful:(RACPOpCode)opCode;
- (void)bgmController:(UHNBGMController*)controller RACPOperation:(RACPOpCode)opCode failed:(RACPResponseCode)responseCode;
- (void)bgmControllerDidGetStoredRecords:(UHNBGMController*)controller;
- (void)bgmController:(UHNBGMController*)controller didGetNumberOfStoredRecords:(NSNumber*)numOfRecords;

@end