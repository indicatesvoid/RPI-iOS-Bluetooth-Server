//
//  ofxBLE.h
//  RPI_iOS_Server
//
//  Created by William Clark on 11/21/14.
//
//

// define an interface for ofApp to RedBearLab's BLE Delegate //
// based off of https://github.com/yamazakiharuki/BLE_mini_example //

#pragma once
#import "ofApp.h"
#import "BLE.h"
#import "ofMain.h"
#import "Protocol.h"

@interface ofxBLEDelegate : NSObject <BLEDelegate> {
    BLE* ble;
}

@property (assign, atomic)      ofApp* dataDelegate;
@property (strong, nonatomic)   BLE *ble;
@property unsigned char * receivedData;
@property int dataLength;

@end

// C++ interface //
// (Obj-C may be a superset of C, but this just makes interopability
// easier with oF)
class ofxBLE {
    protected:
        ofxBLEDelegate *btDelegate;
    
    public:
        ofxBLE();
        ~ofxBLE();
    
        void scanPeripherals();
        void sendPosition(uint8_t x, uint8_t y);
    
//        void sendDigitalOut(bool bState);
//        void setAnalogInput(bool bState);
//        void setDataDelegate(ofApp* delegate);
//        void sendServo(float _val);
//    
//        unsigned char * receivedDATA;
//        int lengthOfDATA;
    
    bool isConnected();
};