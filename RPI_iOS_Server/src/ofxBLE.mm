//
//  ofxBLE.m
//  RPI_iOS_Server
//
//  Created by William Clark on 11/21/14.
//
//

#import <Foundation/Foundation.h>
#include "ofxBLE.h"

@interface ofxBLEDelegate ()
@end

@implementation ofxBLEDelegate

@synthesize dataDelegate;
// etc... //

- (id)init {
    [super init];
    ble = [[BLE alloc] init];
    [ble controlSetup];
    ble.delegate = self;
    
    return self;
}

#pragma mark - connection
- (void)scanForPeripherals
{
    // disconnect from currently active peripheral, if there is one //
    if (ble.activePeripheral)
        if(ble.activePeripheral.isConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    // scan //
    [ble findBLEPeripherals:2];
    
    // set timer to connect after n-number of seconds //
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

-(void) connectionTimer:(NSTimer *)timer
{
//    NSLog(@"found %@ peripherals", ble.peripherals.count);
    if (ble.peripherals.count > 0)
    {
        // connect to first available peripheral //
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
}

#pragma mark - send methods
-(void)sendOpcode:(Opcodes)opcode withPayload:(uint8_t*)payload {
    // to-do: check/enforce length of data array
    UInt8 buf[PACKET_SIZE] = { (uint8_t)opcode, payload[0], payload[1] };
    
    NSData* data = [[NSData alloc] initWithBytes:buf length:PACKET_SIZE];
    [ble write:data];
}

-(void)sendPositionX:(uint8_t)x withY:(uint8_t)y {
    uint8_t payload[2] = { x, y };
    [self sendOpcode:SET_POSITION withPayload:payload];
}

#pragma mark - BLE Delegate
- (void)bleDidConnect {
    NSLog(@"->Connected");
}

- (void)bleDidDisconnect {
    NSLog(@"->Disconnected");
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length {
    
}

@end

// = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
//                                          C++ class implementation

ofxBLE::ofxBLE() {
    btDelegate = [[ofxBLEDelegate alloc] init];
}

ofxBLE::~ofxBLE() {
    
}

void ofxBLE::scanPeripherals(){
    [btDelegate scanForPeripherals];
}

void ofxBLE::sendPosition(uint8_t x, uint8_t y) {
    // position should be NORMALIZED to between 0 and 255 BEFORE
    // passing into this method!
    [btDelegate sendPositionX:x withY:y];
}

