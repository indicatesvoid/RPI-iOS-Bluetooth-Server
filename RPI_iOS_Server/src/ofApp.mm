#include "ofApp.h"
#include "ofxBLE.h"
#import "ofxBLE.h"

#define CIRCLE_RADIUS 30
#define TOUCH_ERROR 12

ofTrueTypeFont TextButton::mFont;

//--------------------------------------------------------------
void ofApp::setup(){	
    ofBackground(ofColor::black);
    
    scanBtn = new TextButton("Scan", 0, 0, ofGetWidth());
    
    // init ble //
    ble = new ofxBLE();
    
    // variable init //
    draggingCircle = false;
    circleX = ofGetWindowWidth()/2;
    circleY = ofGetWindowHeight()/2;
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
	ofCircle(circleX, circleY, CIRCLE_RADIUS);
    
    scanBtn->draw();
}

//--------------------------------------------------------------
void ofApp::exit(){
    delete scanBtn;
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    scanBtn->isTouchInside(touch.x, touch.y);
    
    // test if touch point is within circle //
    ofLogNotice("touch x, y: " + ofToString(touch.x) + " , " + ofToString(touch.y));
    ofLogNotice("circle x, y: " + ofToString(circleX) + " , " + ofToString(circleY));
    if(touch.x >= circleX-TOUCH_ERROR && touch.x <= circleX + (CIRCLE_RADIUS/2) + TOUCH_ERROR) {
        if(touch.y >= circleY-TOUCH_ERROR && touch.y <= circleY+(CIRCLE_RADIUS/2)+TOUCH_ERROR) {
            draggingCircle = true;
        }
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    if(draggingCircle) {
        circleX = touch.x;
        circleY = touch.y;
        
        // normalize to 0-255 //
        float nx = ofNormalize(circleX, 0, ofGetWindowWidth());
        float ny = ofNormalize(circleY, 0, ofGetWindowHeight());
        
        // ofNormalize returns a value between 0 and 1
        // multiply this by 255 to get a value between
        // 0 and 255, since we will be sending an 8-bit
        // unsigned int across
        nx *= 255;
        ny *= 255;
        
        ble->sendPosition((uint8_t)nx, (uint8_t)ny);
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    draggingCircle = false;
    
    if(scanBtn->pressed) {
        ofLogNotice("scan button pressed");
        scanBtn->pressed = false;
        
        ble->scanPeripherals();
    }
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
