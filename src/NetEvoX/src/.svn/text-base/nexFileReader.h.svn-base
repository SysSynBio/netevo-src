/**
 * nexFileReader
 *
 * Reader for NetEvoX network evolution streams. Runs as a separate thread to allow
 * for evolution data to be read while visualisation takes place.
 *
 * Author: Thomas E. Gorochowski
 *
 */

#pragma once

#include "ofxThread.h"
#include "nexLayout.h"


class nexFileReader : public ofxThread{

public:
	bool  playing;
	nexFileReader(nexLayout *newLayout, char *newFile);
	void threadedFunction();
	void startReading();
	char * getFilename();
	void stop();
	
private:
	char         theFile[1024];
	nexLayout   *layout;
	ifstream    *myfile;
	
	void readFile(char *filename);
};

