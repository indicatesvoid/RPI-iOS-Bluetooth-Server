//
//  Button.h
//  Simple button for openFrameworks iOS app (not relying on UIKit)
//
//  Created by William Clark on 11/21/14.
//
//

#pragma once
#include "ofMain.h"

class Button{
    
public:
    Button(int posX, int posY, int w=0){
        int width = (w == 0) ? ofGetWidth() : w;
        bounds = ofRectangle(posX, posY, width, HEIGHT);
    };
    
    virtual void draw(){
        ofPushStyle();
        ofSetColor(pressed ? ofColor::darkRed : ofColor::grey);
        ofRect(bounds);
        ofPopStyle();
    };
    
    bool isTouchInside(int touchX, int touchY) {
        pressed = this->bounds.inside(touchX, touchY);
        return pressed;
    }
    
    bool pressed;
    ofRectangle bounds;
    static const int HEIGHT = 80;
    static const int PADDING = 5;
private:
};

class TextButton : public Button {
    
public:
    TextButton(string label, int posX, int posY, int w=0) : Button(posX, posY, w) {
        setLabel(label);
    };
    
    void setLabel(string text) {
        mLabel = text;
        if (mFont.isLoaded() == false){
            mFont.loadFont("fonts/verdana.ttf", 30, true, true);
            mFont.setLineHeight(34.0f);
            mFont.setLetterSpacing(1.035);
        }
        mLabelBounds = mFont.getStringBoundingBox(mLabel, 0, 0);
    }
    
    void draw(){
        Button::draw();
        ofSetColor(ofColor::white);
        mFont.drawString(mLabel,
                         bounds.x + bounds.width/2 - (mLabelBounds.width/2),
                         bounds.y + bounds.height/2 + (mLabelBounds.height/2));
    };
    
private:
    string mLabel;
    ofRectangle mLabelBounds;
    static ofTrueTypeFont mFont;
};

class ImageButton : public Button {
public:
    ImageButton(ofImage icon, int posX, int posY, int w=0) : Button(posX, posY, w) {
        mIcon = &icon;
        setBounds(posX, posY, w);
    }
    
    ImageButton(string path, int posX, int posY, int w=0) : Button(posX, posY, w) {
        mIcon = new ofImage();
        if(!mIcon->loadImage(path)) {
            ofLogError("Error loading button image.");
        } else {
            setBounds(posX, posY, w);
        }
    }
    
    void draw() {
        Button::draw();
        mIcon->draw(mIconBounds.x, mIconBounds.y, IMG_HEIGHT, mImgWidth);
    }
    
    static const int IMG_HEIGHT = Button::HEIGHT - (Button::HEIGHT/2);
private:
    ofImage* mIcon;
    ofRectangle mIconBounds;
    int mImgWidth;
    
    void setBounds(int x, int y, int w) {
        mImgWidth = (IMG_HEIGHT/mIcon->getHeight()) * mIcon->getWidth();
        mIconBounds = ofRectangle(Button::bounds.x + (Button::bounds.width /2) - (mImgWidth/2), Button::bounds.y + (Button::bounds.height/2) - (IMG_HEIGHT/2), mImgWidth, IMG_HEIGHT);
    }
};