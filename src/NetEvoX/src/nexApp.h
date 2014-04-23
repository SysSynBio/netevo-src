/**
 * nexApp
 *
 * Application class that handles all user input and acts as a controller
 * for all other objects during the simulation.
 *
 * Author: Thomas E. Gorochowski
 *
 */

#pragma once

#include "nexFileReader.h"
#include "nexAgedLayout2D.h"
#include "ofxQtVideoSaver.h"


class nexApp : public ofBaseApp{
	
public:
	nexLayout          *layout;
	nexFileReader      *reader;
	ofxQtVideoSaver	    movieSaver;
	bool                recording;
	
	void setup();
	void update();
	void draw();
	
	void keyPressed(int key);
	void keyReleased(int key);
	
	void mouseMoved(int x, int y);
	void mouseDragged(int x, int y, int button);
	void mousePressed(int x, int y, int button);
	void mouseReleased();
	
	void loadNetwork(char *theFile);
	
	void play();
	bool playing();
	void reset();
	
	void startRecording(char *theFile);
	void stopRecording();

private:
	bool info;
};

