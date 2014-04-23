/**
 * nexUIController
 *
 * Controller for the Cocoa UI. Handles all user input except for mouse and
 * key presses. Very light binding to the actual OpenFrameworks library which
 * should allow for changes to be accomodated easily.
 *
 * Author: Thomas E. Gorochowski
 *
 */

#ifndef _NEX_UI_CONTROLLER
#define _NEX_UI_CONTROLLER

#include "nexApp.h"
#import <Cocoa/Cocoa.h>

@interface nexUIController : NSWindowController {
	IBOutlet id nexControlPanel;
	IBOutlet id nexEditLayoutPanel;
	
	IBOutlet id nexPlayButton;
	IBOutlet id nexRecordButton;
	IBOutlet id nexRecordLabel;
	IBOutlet id nexRecordSpinner;
	
	nexApp *theApp;
}

- (id) init;

- (IBAction)  openNetwork:(id)sender;
- (void)      openNetworkDialogDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode 
						  contextInfo:(void *)contextInfo;
- (void)      openNetworkFromFile:(NSString *)aFile;

- (IBAction)  editLayout:(id)sender;
- (IBAction)  doneEditingLayout:(id)sender;

- (IBAction)  bgColourWell:(id)sender;
- (IBAction)  defNodeColourWell:(id)sender;
- (IBAction)  defEdgeColourWell:(id)sender;

- (IBAction)  blendFromColourWell:(id)sender;
- (IBAction)  blendToColourWell:(id)sender;

- (IBAction)  nodeSpacing:(id)sender;
- (IBAction)  ageingRate:(id)sender;

- (IBAction)  layoutStyle:(id)sender;

- (IBAction)  play:(id)sender;
- (IBAction)  reset:(id)sender;

- (IBAction)  evoSpeed:(id)sender;
- (IBAction)  dynSpeed:(id)sender;

- (IBAction)  outputToEPS:(id)sender;
- (void)      outToEPSDialogDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode 
									 contextInfo:(void *)contextInfo;

- (IBAction)  record:(id)sender;
- (void)      saveRecordingDialogDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode 
							contextInfo:(void *)contextInfo;

@end

#endif
