/**
 * nexAgedLayout
 *
 * Performs layout of the network using the an ageing approach to ensure
 * that more stable regions see smaller movement. Makes extensive use of
 * the MSAPhysics library to perform the forced directed layout.
 *
 * Author: Thomas E. Gorochowski
 *
 */

#pragma once


#include "MSAPhysics.h"
#include "ofxVectorGraphics.h"

using namespace std;
using namespace MSA;

struct nexNodeData_t {
	float    state; // Node state
	ofColor  col;   // Node colour
	long     age;   // Node age
	Vec3f    pos;   // Node position (if fixed)
};

struct nexEdgeData_t {
	float    state; // Edge state
	ofColor  col;   // Edge colour
	long     age;   // Edge age
	float    drag;  // Used for calculating opacity
};

class nexAgedLayout2D : public nexLayout {
	
public:
	nexAgedLayout2D();
	
	void step();
	void update();
	void draw();
	void clear();
	
	void addNode();
	void removeNode(int node);
	void addEdge(int source, int target);
	void removeEdge(int source, int target);
	
	void setNodeState(int node, float state);
	void setNodePos(int node, float x, float y, float z);
	void setNodeCol(int node, float r, float g, float b, float a);
	void manualNodePos(bool manualPos);
	void manualNodeCol(bool manualCol);
	
	void setEdgeState(int source, int target, float state);
	void setEdgeCol(int source, int target, float r, float g, float b, float a);
	void manualEdgeCol(bool manualCol);
	
	void setBackgroundColour(float r, float g, float b);
	void setDefaultNodeColour(float r, float g, float b, float a);
	void setDefaultEdgeColour(float r, float g, float b, float a);
	
	void setNodeSpacing(float spacing);
	void setAgeingRate(float rate);
	
	void setLayoutStyle(int newStyle);
	
	void setBlendFromColour(float r, float g, float b, float a);
	void setBlendToColour(float r, float g, float b, float a);
	
	void outputToEPS(char *filename);
	
private:
	Physics::World   physics;  // Layout physics engine
	float            scale;    // Scale of the view (so everything is shown)
	Vec2f            centroid; // Centre of the scene
	float            stretch;  // How stretched the edges are (aid with viewing)
	float            ageingRate;
	
	ofColor          defBGCol;
	ofColor          defNodeCol;
	ofColor          defEdgeCol;
	
	ofColor          blendFromCol;
	ofColor          blendToCol;
	
	NEX_LAYOUT_STYLE_T style; // Style of the layout
	
	bool             manNodePos;
	bool             manNodeCol;
	bool             manEdgeCol;
	
	ofxVectorGraphics epsOutput;
	
	void resetNodeAge(int node);
	void resetEdgeAge(int source, int target);
	void ageNodes();
	void ageEdges();
	
	void updateMasses();
	void updateCentroid();
};


