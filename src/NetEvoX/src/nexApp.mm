

#include <stdlib.h>
#include <mach/semaphore.h>
#include <mach/task.h>
#include "nexApp.h"
#import <Cocoa/Cocoa.h>

int evoDelay = 500;
int dynDelay = 1;
NSObject *controlOwner;
nexFileReader *theReader;
semaphore_t updateSem;


void nexApp::setup(){
	
	cout << "[NetEvoX] Seting up NetEvoX.\n";
	
	/* Create semaphore for handling update concurrent screen updates */
	semaphore_create(mach_task_self(), &updateSem, SYNC_POLICY_FIFO, 1);
	
	ofSetWindowTitle("NetEvoX");
	
	/* Load the control panel */
	controlOwner = [[NSObject alloc] retain];
	[NSBundle loadNibNamed:@"nexApp" owner:controlOwner];
	
	info = false;
	
	/* Create basic objects */
	layout = new nexAgedLayout2D();
	reader = NULL;
	recording = false;
	
	/* Setup OF properties */
	ofSetFrameRate(30);
	ofSetVerticalSync(true);
	ofEnableSmoothing();
	ofEnableAlphaBlending();
}


void nexApp::update() {
	
	/* Movie recording */
	ofImage grab;
	if (recording){
		grab.grabScreen(0, 0, ofGetWidth(), ofGetHeight());
		movieSaver.addFrame(grab.getPixels(), 1.0f / 30.0f);
	}

	/* Update the layout */
	layout->update();
}


void nexApp::draw() {
	
	/* Plot simulation information */
	if (info) {
		ofSetColor(100,100,100);
		if (reader != NULL) ofDrawBitmapString(reader->getFilename(), 20,20);
		ofDrawBitmapString(ofToString(evoDelay, 0), 20,35);
		ofDrawBitmapString(ofToString(ofGetFrameRate(), 2), 20, 50);
	}
	
	/* Draw the layout */
	layout->draw();
}


void nexApp::keyPressed(int key){
	
	switch (key) {
			
		case 'i':
			info = !info;
			break;

	}
}


void nexApp::keyReleased(int key){
}
void nexApp::mouseMoved(int x, int y ) {
}
void nexApp::mouseDragged(int x, int y, int button){
}
void nexApp::mousePressed(int x, int y, int button){
}
void nexApp::mouseReleased(){
}


void nexApp::loadNetwork(char *theFile){
	
	cout << "[NetEvoX] Loading network file: " << theFile << "\n";

	if (reader == NULL) {
		reader = new nexFileReader(layout, theFile);
		theReader = reader;
	}
	else {
		// Kill current reader thread
		// Signal update semaphore
		// Create new reader
		if (reader != NULL) {
			reader->unlock();
			reader->stop();
			delete reader;
		}
		layout->clear();
		reader = new nexFileReader(layout, theFile);
		theReader = reader;
	}
}


void nexApp::play(){

	if (reader != NULL) {
	
		if (reader->playing) {
			cout << "[NetEvoX] Pause simulation.\n";
			reader->lock();
			reader->playing = false;
		}
		else {
			cout << "[NetEvoX] Play simulation.\n";
			reader->unlock();
			reader->startReading();
			reader->playing = true;
		}
	}
}


bool nexApp::playing(){
	if (reader != NULL) return reader->playing;
	else return false;
}


void nexApp::reset(){
	char theFile[1024];
	if (reader != NULL) {
		reader->unlock();
		reader->stop();
		strcpy(theFile, reader->getFilename());
		delete reader;
		layout->clear();
		reader = new nexFileReader(layout, theFile);
		theReader = reader;
	}
}


void nexApp::startRecording(char *theFile){
	cout << "[NetEvoX] Starting to record movie.\n";
	movieSaver.setCodecType(2);
	movieSaver.setCodecQualityLevel(OF_QT_SAVER_CODEC_QUALITY_NORMAL);
	movieSaver.setup(ofGetWidth(), ofGetHeight(), theFile);
	recording = true;
}


void nexApp::stopRecording(){
	cout << "[NetEvoX] Finishing movie.\n";
	movieSaver.finishMovie();
	recording = false;
}

