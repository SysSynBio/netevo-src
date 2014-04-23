
#include "ofMain.h"
#include "nexApp.h"
#import <Cocoa/Cocoa.h>

int main(){
	/* Setup the OpenGL context and run the application */
    ofSetupOpenGL(700, 700, OF_WINDOW);
	ofRunApp(new nexApp());
}
