/**
 * nexLayout
 *
 * Pure virtual class that contains the main interface for layouts to be used by
 * nexApp. Didn't use interface incase there are additional non-virtual functions
 * that might want to be added at a later date.
 *
 * Author: Thomas E. Gorochowski
 *
 */

#pragma once

enum NEX_LAYOUT_STYLE_T {
	NEX_LAYOUT_STYLE_STD = 0,
	NEX_LAYOUT_STYLE_ALPHA_AGED = 1,
	NEX_LAYOUT_STYLE_BLEND_AGED = 2,
	NEX_LAYOUT_STYLE_NO_AGEING = 3
};

class nexLayout {
	
public:
	/* Called at the end of an evolutionary step */
	virtual void step() = 0;
	
	/* OF based calls to update graphics */
	virtual void update() = 0;
	virtual void draw() = 0;
	virtual void clear() = 0;
	
	/* Methods to manipulate the network */
	virtual void addNode() = 0;
	virtual void removeNode(int node) = 0;
	virtual void addEdge(int source, int target) = 0;
	virtual void removeEdge(int source, int target) = 0;
	
	/* Methods to set node and edge attributes */
	virtual void setNodeState(int node, float state) = 0;
	virtual void setNodePos(int node, float x, float y, float z) = 0;
	virtual void setNodeCol(int node, float r, float g, float b, float a) = 0;
	virtual void manualNodePos(bool manualPos) = 0;
	virtual void manualNodeCol(bool manualCol) = 0;
	virtual void setEdgeState(int source, int target, float state) = 0;
	virtual void setEdgeCol(int source, int target, float r, float g, float b, float a) = 0;
	virtual void manualEdgeCol(bool manualCol) = 0;
	
	virtual void setBackgroundColour(float r, float g, float b) = 0;
	virtual void setDefaultNodeColour(float r, float g, float b, float a) = 0;
	virtual void setDefaultEdgeColour(float r, float g, float b, float a) = 0;
	
	virtual void setNodeSpacing(float spacing) = 0;
	virtual void setAgeingRate(float rate) = 0;
	
	virtual void setLayoutStyle(int newStyle) = 0;
	
	virtual void setBlendFromColour(float r, float g, float b, float a) = 0;
	virtual void setBlendToColour(float r, float g, float b, float a) = 0;
	
	virtual void outputToEPS(char *filename) = 0;
};
#pragma once
