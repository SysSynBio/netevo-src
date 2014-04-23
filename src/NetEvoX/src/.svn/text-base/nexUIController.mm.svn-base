
#import "nexUIController.h"
#include "nexLayout.h"

extern int evoDelay;
extern int dynDelay;

@implementation nexUIController


- (id) init {
    self = [super init];
    theApp = (nexApp*)ofGetAppPtr();
    return self;
}


- (IBAction) openNetwork:(id)sender
{
	// Create the open panel, open as sheet, and setup delgate function
	NSOpenPanel *openDialog = [NSOpenPanel openPanel];
	// Only allow single file selections
	[openDialog setAllowsMultipleSelection:NO];
	[openDialog beginSheetForDirectory:nil
								  file:nil
								 types:nil
						modalForWindow:nexControlPanel
						 modalDelegate:self
						didEndSelector:@selector(openNetworkDialogDidEnd:returnCode:contextInfo:)
						   contextInfo:nil];	
}


- (void) openNetworkDialogDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	[sheet orderOut:self];
	// OK button was pressed
	
	if(returnCode == NSOKButton){
		// Get the selected files and check that only one exists
		NSArray *selectedURLs = [sheet URLs];
		if([selectedURLs count] == 1){
			NSURL *networkURL;
			networkURL = (NSURL *)[selectedURLs objectAtIndex:0];
			[self openNetworkFromFile:[networkURL path]];
		}
	}
}


- (void) openNetworkFromFile:(NSString *)aFile
{
	// Pause if simulation running
	if (theApp->playing()) {
		[nexPlayButton setTitle:@"Play"];
	}

	theApp->loadNetwork((char *)[aFile UTF8String]);
}


- (IBAction)  editLayout:(id)sender
{
	[NSApp beginSheet:nexEditLayoutPanel modalForWindow:nexControlPanel
        modalDelegate:self didEndSelector:NULL contextInfo:nil];
}


- (IBAction)  doneEditingLayout:(id)sender
{
	[nexEditLayoutPanel orderOut:nil];
    [NSApp endSheet:nexEditLayoutPanel];
}


- (IBAction)  bgColourWell:(id)sender
{
	theApp->layout->setBackgroundColour([[sender color] redComponent]   *255, 
										[[sender color] greenComponent] *255, 
										[[sender color] blueComponent]  *255);
}


- (IBAction)  defNodeColourWell:(id)sender
{
	theApp->layout->setDefaultNodeColour([[sender color] redComponent]   *255, 
										 [[sender color] greenComponent] *255, 
										 [[sender color] blueComponent]  *255,
										 [[sender color] alphaComponent] *255);
}


- (IBAction)  defEdgeColourWell:(id)sender
{
	theApp->layout->setDefaultEdgeColour([[sender color] redComponent]   *255, 
										 [[sender color] greenComponent] *255, 
										 [[sender color] blueComponent]  *255,
										 [[sender color] alphaComponent] *255);
}


- (IBAction)  blendFromColourWell:(id)sender
{
	theApp->layout->setBlendFromColour([[sender color] redComponent]   *255, 
									   [[sender color] greenComponent] *255, 
									   [[sender color] blueComponent]  *255,
									   [[sender color] alphaComponent] *255);
}


- (IBAction)  blendToColourWell:(id)sender
{
	theApp->layout->setBlendToColour([[sender color] redComponent]   *255, 
									 [[sender color] greenComponent] *255, 
									 [[sender color] blueComponent]  *255,
									 [[sender color] alphaComponent] *255);
}


- (IBAction)  nodeSpacing:(id)sender
{
	theApp->layout->setNodeSpacing((float)[sender doubleValue]);
}


- (IBAction)  ageingRate:(id)sender
{
	theApp->layout->setAgeingRate((float)[sender doubleValue]);
}


- (IBAction)  layoutStyle:(id)sender
{
	theApp->layout->setLayoutStyle((int)[sender indexOfSelectedItem]);
}


- (IBAction) play:(id)sender
{
	theApp->play();
	if (theApp->playing()) [nexPlayButton setTitle:@"Pause"];
	else [nexPlayButton setTitle:@"Play"];
}


- (IBAction)  reset:(id)sender
{
	if (theApp->playing()) [nexPlayButton setTitle:@"Play"];
	theApp->reset();
}


- (IBAction) evoSpeed:(id)sender
{
	evoDelay = (int)[sender doubleValue];
}

- (IBAction)  dynSpeed:(id)sender
{
	dynDelay = (int)[sender doubleValue];
}


- (IBAction)  outputToEPS:(id)sender
{
	NSSavePanel *outputDialog = [NSSavePanel savePanel];
	[outputDialog beginSheetForDirectory:nil
											  file:nil
								 modalForWindow:nexControlPanel
								  modalDelegate:self
								 didEndSelector:@selector(outToEPSDialogDidEnd:returnCode:contextInfo:)
									 contextInfo:nil];
}


- (void) outToEPSDialogDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode 
							  contextInfo:(void *)contextInfo
{
	[sheet orderOut:self];
	if(returnCode == NSOKButton){
		theApp->layout->outputToEPS((char*)[[[sheet URL] path] UTF8String]);
	}
}


- (IBAction) record:(id)sender
{
	if (theApp->recording) {
		theApp->stopRecording();
		[nexRecordButton setTitle:@"Start Recording..."];
		[nexRecordSpinner stopAnimation:self];
		[nexRecordLabel setHidden:YES];
		[nexRecordSpinner setHidden:YES];
		float delta = -23;
		NSRect frame = [nexControlPanel frame];
		frame.origin.y -= delta;
		frame.size.height += delta;
		[nexControlPanel setFrame: frame
						   display: YES
						   animate: YES];
	}
	else {
		NSSavePanel *saveDialog = [NSSavePanel savePanel];
		[saveDialog beginSheetForDirectory:nil
									  file:nil
							modalForWindow:nexControlPanel
							 modalDelegate:self
							didEndSelector:@selector(saveRecordingDialogDidEnd:returnCode:contextInfo:)
							   contextInfo:nil];
	}
}


- (void) saveRecordingDialogDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	[sheet orderOut:self];
	if(returnCode == NSOKButton){
		theApp->startRecording((char*)[[[sheet URL] path] UTF8String]);
		[nexRecordButton setTitle:@"Stop Recording"];

		float delta = 23;
		NSRect frame = [nexControlPanel frame];
		frame.origin.y -= delta;
		frame.size.height += delta;
		[nexControlPanel setFrame: frame
						   display: YES
						   animate: YES];

		[nexRecordLabel setHidden:NO];
		[nexRecordSpinner setHidden:NO];
		[nexRecordSpinner startAnimation:self];
	}
}


@end
