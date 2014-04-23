
#include <mach/semaphore.h>
#include <mach/task.h>
#include "nexFileReader.h"
#include "nexAgedLayout2D.h"

#define E_CONST 2.71828182
#define DEF_DRAG 0.98f

extern nexFileReader *theReader;
extern semaphore_t updateSem;

using namespace MSA;


nexAgedLayout2D::nexAgedLayout2D(){
	scale      = 1;
	centroid.x = 0;
	centroid.y = 0;
	stretch    = 0.08;
	ageingRate = 0.02;
	
	defBGCol.r = 255;
	defBGCol.g = 255;
	defBGCol.b = 255;
	defBGCol.a = 255;
	
	defNodeCol.r = 144;
	defNodeCol.g = 202;
	defNodeCol.b = 235;
	defNodeCol.a = 255;
	
	defEdgeCol.r = 50;
	defEdgeCol.g = 50;
	defEdgeCol.b = 50;
	defEdgeCol.a = 255;
	
	blendFromCol.r = 255;
	blendFromCol.g = 0;
	blendFromCol.b = 0;
	blendFromCol.a = 255;
	
	blendToCol.r = 0;
	blendToCol.g = 0;
	blendToCol.b = 255;
	blendToCol.a = 255;
	
	style  = NEX_LAYOUT_STYLE_STD;
	
	manNodePos = false;
	manNodeCol = false;
	manEdgeCol = false;
	
	physics.clear();
	physics.setGravity(0.0);
	physics.setDrag(1.0f);
	physics.setTimeStep(0.01f);
	physics.setSectorCount(1);
	physics.disableCollision();
}


void nexAgedLayout2D::step(){
	ageNodes();
	ageEdges();
}


void nexAgedLayout2D::update(){
	draw();
}


void nexAgedLayout2D::draw(){
	
	float x, y, z, newDrag, nodeSize, dR, dG, dB, dA;
	
	ofBackground(defBGCol.r, defBGCol.g, defBGCol.b);
	
	semaphore_wait(updateSem);
	
		if ( physics.numberOfParticles() > 1 ) {
			physics.update();
			updateCentroid();
		}
		
		ofTranslate( ofGetWidth()/2 , ofGetHeight()/2 );
		ofScale( scale*(0.8*(1.0/stretch)), scale*(0.8*(1.0/stretch)), scale*(0.8*(1.0/stretch)));
		ofTranslate( -centroid.x * stretch, -centroid.y * stretch );
	
		for(int i=0; i<physics.numberOfSprings(); i++) {
			Physics::Spring *spring = (Physics::Spring *) physics.getSpring(i);
			
			if(!spring->isDead()){
				Physics::Particle *a = spring->getA();
				Physics::Particle *b = spring->getB();
				
				if (style == NEX_LAYOUT_STYLE_NO_AGEING) {
					((nexEdgeData_t *)(spring->data))->drag = DEF_DRAG;
				}
				else {
					newDrag = 1.0 - ((1.0 / (1.0 + pow(E_CONST, -2.0*ageingRate*((nexEdgeData_t *)(spring->data))->age))) - 0.5) * 2.0;
					// Make sure we don't get negative drag
					if (newDrag < 0.0) ((nexEdgeData_t *)(spring->data))->drag = 0.0f;
					else ((nexEdgeData_t *)(spring->data))->drag = newDrag;
				}
				
				ofSetLineWidth(((nexEdgeData_t *)(spring->data))->state);
				
				if (manEdgeCol) {
					switch (style) {
						case NEX_LAYOUT_STYLE_STD:
						case NEX_LAYOUT_STYLE_BLEND_AGED:
						case NEX_LAYOUT_STYLE_NO_AGEING:
							ofSetColor((int)((nexEdgeData_t *)(spring->data))->col.r,
									   (int)((nexEdgeData_t *)(spring->data))->col.g,
									   (int)((nexEdgeData_t *)(spring->data))->col.b,
									   (int)((nexEdgeData_t *)(spring->data))->col.a);							
							break;
						
						case NEX_LAYOUT_STYLE_ALPHA_AGED:
							ofSetColor((int)((nexEdgeData_t *)(spring->data))->col.r,
									   (int)((nexEdgeData_t *)(spring->data))->col.g,
									   (int)((nexEdgeData_t *)(spring->data))->col.b,
									   (int)((nexEdgeData_t *)(spring->data))->col.a
									        * (1.0/((nexEdgeData_t *)(spring->data))->age)*10+40);
							break;
						
						default:
							// Do nothing
							break;
					}
				}
				else {
					switch (style) {
						case NEX_LAYOUT_STYLE_STD:
						case NEX_LAYOUT_STYLE_BLEND_AGED:
						case NEX_LAYOUT_STYLE_NO_AGEING:
							ofSetColor(defEdgeCol.r,defEdgeCol.g,defEdgeCol.b,defEdgeCol.a);							
							break;
						
						case NEX_LAYOUT_STYLE_ALPHA_AGED:
							ofSetColor(defEdgeCol.r,defEdgeCol.g,defEdgeCol.b,
									   (int)((nexEdgeData_t *)(spring->data))->col.a
									   * (1.0/((nexEdgeData_t *)(spring->data))->age)*10+40);
							break;
						
						default:
							// Do nothing
							break;
					}
				}

				if (manNodePos) {
					ofLine(((nexNodeData_t *)(a->data))->pos.x*stretch, ((nexNodeData_t *)(a->data))->pos.y*stretch, 
						   ((nexNodeData_t *)(b->data))->pos.x*stretch, ((nexNodeData_t *)(b->data))->pos.y*stretch);
				}
				else {
					ofLine(a->getPosition().x*stretch, a->getPosition().y*stretch, 
						   b->getPosition().x*stretch, b->getPosition().y*stretch);
				}
			}
		}
		
		// Should really only do this when the blended colours change
		if (style == NEX_LAYOUT_STYLE_BLEND_AGED) {
			dR = blendToCol.r - blendFromCol.r;
			dG = blendToCol.g - blendFromCol.g;
			dB = blendToCol.b - blendFromCol.b;
			dA = blendToCol.a - blendFromCol.a;
		}
	
		for(int i=0; i<physics.numberOfParticles(); i++) {
			Physics::Particle *p = physics.getParticle(i);
			
			if (style == NEX_LAYOUT_STYLE_NO_AGEING) {
				p->setDrag(DEF_DRAG);
			}
			else {
				newDrag = 1.0 - ((1.0 / (1.0 + pow(E_CONST, -2.0*ageingRate*((nexNodeData_t *)(p->data))->age))) - 0.5) * 2.0;
				// Make sure we don't get negative drag
				if (newDrag < 0.0) p->setDrag(0.0f);
				else p->setDrag(newDrag);
			}
			
			nodeSize = ((nexNodeData_t *)(p->data))->state;
			
			if (manNodePos) {
				x = ((nexNodeData_t *)(p->data))->pos.x;
				y = ((nexNodeData_t *)(p->data))->pos.y;
			}
			else {
				x = p->getPosition().x;
				y = p->getPosition().y;
			}

			if (manNodeCol) {
			
				switch (style) {
					case NEX_LAYOUT_STYLE_STD:
					case NEX_LAYOUT_STYLE_BLEND_AGED:
					case NEX_LAYOUT_STYLE_NO_AGEING:
						ofSetColor((int)((nexNodeData_t *)(p->data))->col.r,
								   (int)((nexNodeData_t *)(p->data))->col.g,
								   (int)((nexNodeData_t *)(p->data))->col.b,
								   (int)((nexNodeData_t *)(p->data))->col.a);				
						ofFill();
						ofCircle(x*stretch, y*stretch, nodeSize);
						ofSetColor((int)((nexNodeData_t *)(p->data))->col.r*0.8,
								   (int)((nexNodeData_t *)(p->data))->col.g*0.8,
								   (int)((nexNodeData_t *)(p->data))->col.b*0.8,
								   (int)((nexNodeData_t *)(p->data))->col.a);
						ofSetLineWidth(2.0);
						ofNoFill();
						ofCircle(x*stretch, y*stretch, nodeSize);							
						break;
					
					case NEX_LAYOUT_STYLE_ALPHA_AGED:
						ofSetColor((int)((nexNodeData_t *)(p->data))->col.r,
								   (int)((nexNodeData_t *)(p->data))->col.g,
								   (int)((nexNodeData_t *)(p->data))->col.b,
								   ((int)((nexNodeData_t *)(p->data))->col.a
								   *p->getDrag()) + 40);				
						ofFill();
						ofCircle(x*stretch, y*stretch, nodeSize);
						ofSetColor((int)((nexNodeData_t *)(p->data))->col.r*0.8,
								   (int)((nexNodeData_t *)(p->data))->col.g*0.8,
								   (int)((nexNodeData_t *)(p->data))->col.b*0.8,
								   ((int)((nexNodeData_t *)(p->data))->col.a
								   *p->getDrag()) + 40);
						ofSetLineWidth(2.0);
						ofNoFill();
						ofCircle(x*stretch, y*stretch, nodeSize);
						break;
					
					default:
						// Do nothing
						break;
				}	
			}
			else {
				
				switch (style) {
					case NEX_LAYOUT_STYLE_STD:
					case NEX_LAYOUT_STYLE_NO_AGEING:
						ofSetColor(defNodeCol.r,defNodeCol.g,defNodeCol.b,defNodeCol.a);
						ofFill();
						ofCircle(x*stretch, y*stretch, nodeSize);
						ofSetColor(defNodeCol.r*0.8,defNodeCol.g*0.8,defNodeCol.b*0.8,defNodeCol.a);
						ofSetLineWidth(2.0);
						ofNoFill();
						ofCircle(x*stretch, y*stretch, nodeSize);							
						break;
					
					case NEX_LAYOUT_STYLE_ALPHA_AGED:
						ofSetColor(defNodeCol.r,defNodeCol.g,defNodeCol.b, 
								   (defNodeCol.a*p->getDrag()) + 40);				
						ofFill();
						ofCircle(x*stretch, y*stretch, nodeSize);
						ofSetColor(defNodeCol.r*0.8,defNodeCol.g*0.8,defNodeCol.b*0.8,
								   (defNodeCol.a*p->getDrag()) + 40);
						ofSetLineWidth(2.0);
						ofNoFill();
						ofCircle(x*stretch, y*stretch, nodeSize);
						break;
					
					case NEX_LAYOUT_STYLE_BLEND_AGED:
						ofSetColor(blendFromCol.r+(dR*p->getDrag()),
								   blendFromCol.g+(dG*p->getDrag()),
								   blendFromCol.b+(dB*p->getDrag()),
								   blendFromCol.a+(dA*p->getDrag()));				
						ofFill();
						ofCircle(x*stretch, y*stretch, nodeSize);
						ofSetColor(blendFromCol.r+(dR*p->getDrag())*0.8,
								   blendFromCol.g+(dG*p->getDrag())*0.8,
								   blendFromCol.b+(dB*p->getDrag())*0.8,
								   blendFromCol.a+(dA*p->getDrag()));
						ofSetLineWidth(2.0);
						ofNoFill();
						ofCircle(x*stretch, y*stretch, nodeSize);
						break;
					
					default:
						// Do nothing
						break;
				}	
			}
		}
	
	semaphore_signal(updateSem);
}


void nexAgedLayout2D::clear(){
	scale = 1;
	centroid.x = 0;
	centroid.y = 0;
	physics.clear();
}


void nexAgedLayout2D::addNode(){
	int i,n;
	Physics::Particle *a;
	
	float posX		= ofRandom(1, 100);
	float posY		= ofRandom(1, 100);
	float posZ		= 0.0f;
	float mass		= 1.0f;

	Physics::Particle *p = physics.makeParticle(Vec3f(posX, posY, posZ), mass, DEF_DRAG);
	p->data = (nexNodeData_t *)malloc(sizeof(struct nexNodeData_t));
	((nexNodeData_t *)(p->data))->state = 1.0f;
	((nexNodeData_t *)(p->data))->age = 1;
	((nexNodeData_t *)(p->data))->pos.x = 0.0;
	((nexNodeData_t *)(p->data))->pos.y = 0.0;
	((nexNodeData_t *)(p->data))->pos.z = 0.0;
	((nexNodeData_t *)(p->data))->col.r = 1;
	((nexNodeData_t *)(p->data))->col.g = 1;
	((nexNodeData_t *)(p->data))->col.b = 1;
	((nexNodeData_t *)(p->data))->col.a = 255;
	
	for (i=0; i<physics.numberOfParticles(); i++){
		a = physics.getParticle(i);
		if (a != p){
			// Add repulsion (-ve attraction) to all other nodes
			physics.makeAttraction(p, a, -10.0f);
		}
	}
}


void nexAgedLayout2D::removeNode(int node){
	int i;
	// Check that the node exists
	if(node < physics.numberOfParticles()){
		// Remove node from environment
		Physics::Particle *p = physics.getParticle(node);
		p->kill();
	}
	else {
		cout << "Error: Tried to remove node that didn't exist." << endl;
	}
}


void nexAgedLayout2D::addEdge(int source, int target){
	Physics::Spring *s;
	// Check that the nodes exists
	if(source < physics.numberOfParticles() && target < physics.numberOfParticles()){
		// Add spring (attraction)
		Physics::Particle *a = physics.getParticle(source);
		Physics::Particle *b = physics.getParticle(target);
		s = physics.makeSpring(a, b, 0.05, 10);
		s->data = (nexEdgeData_t *)malloc(sizeof(struct nexEdgeData_t));
		((nexEdgeData_t *)(s->data))->age = 1;
		((nexEdgeData_t *)(s->data))->drag = DEF_DRAG;
		((nexEdgeData_t *)(s->data))->state = 2.5f;
		((nexEdgeData_t *)(s->data))->col.r = 1;
		((nexEdgeData_t *)(s->data))->col.g = 1;
		((nexEdgeData_t *)(s->data))->col.b = 1;
		((nexEdgeData_t *)(s->data))->col.a = 255;
		// Update ageing on source and target nodes
		resetNodeAge(source);
		resetNodeAge(target);
	}
}


void nexAgedLayout2D::removeEdge(int source, int target){
	// Check that the nodes exists
	if(source < physics.numberOfParticles() && target < physics.numberOfParticles()){
		int i;
		// The nodes to find
		Physics::Particle *a = physics.getParticle(source);
		Physics::Particle*b = physics.getParticle(target);
		// The current nodes for the selected spring
		Physics::Particle *x, *y;
		Physics::Spring *s;
		// Search for a spring between the nodes
		for(i=0; i<physics.numberOfSprings(); i++){
			s = physics.getSpring(i);
			x = s->getA();
			y = s->getB();
			if( (x==a && y==b) || (x==b && y==a) ){
				// Remove spring (attraction)
				s->kill();
			}
		}
	}
}


void nexAgedLayout2D::resetNodeAge(int node){
	((nexNodeData_t *)(physics.getParticle(node)->data))->age = 1;
}


void nexAgedLayout2D::resetEdgeAge(int source, int target){
	Physics::Spring   *s;
	Physics::Particle *a = physics.getParticle(source);
	Physics::Particle *b = physics.getParticle(target);
	
	for (int i=0; i<physics.numberOfSprings(); i++){
		s = physics.getSpring(i);
		if((a == s->getA() && b == s->getB()) ||
		   (b == s->getA() && a == s->getB()))
			((nexEdgeData_t *)(s->data))->age = 1;
	}
}


void nexAgedLayout2D::ageNodes(){
	for(int i=0; i<physics.numberOfParticles(); i++)
		((nexNodeData_t *)(physics.getParticle(i)->data))->age += 1;
}


void nexAgedLayout2D::ageEdges(){
	for(int i=0; i<physics.numberOfSprings(); i++)
		((nexEdgeData_t *)(physics.getSpring(i)->data))->age += 1;
}


void nexAgedLayout2D::updateMasses(){
	int i;
	Physics::Particle *p;
	
	for(i=0; i<physics.numberOfParticles(); i++){
		p = physics.getParticle(i);
		p->setMass(((float)i)/10.0);
	}
}


void nexAgedLayout2D::updateCentroid(){
	float xMax, xMin, yMin, yMax, x, y, z;
	Physics::Particle *p;
	
	if (physics.numberOfParticles() > 1){
		xMax = 110;
		xMin = -10;
		yMax = 110;
		yMin = -10;
	}
	
	for ( int i = 0; i < physics.numberOfParticles(); i++ )
	{
		p = physics.getParticle( i );
		if (manNodePos) {
			x = ((nexNodeData_t *)(p->data))->pos.x;
			y = ((nexNodeData_t *)(p->data))->pos.y;
			//z = ((nexNodeData_t *)(p->data))->pos.z;
		}
		else {
			x = p->getPosition().x;
			y = p->getPosition().y;
			//z = p->getPosition().z;
		}
		xMax = max( xMax, x );
		xMin = min( xMin, x );
		yMin = min( yMin, y );
		yMax = max( yMax, y );
	}
	
	float deltaX = xMax-xMin;
	float deltaY = yMax-yMin;
	
	centroid.x = xMin + 0.5*deltaX;
	centroid.y = yMin + 0.5*deltaY;
	
	if ( deltaY > deltaX )
		scale = ofGetHeight()/(deltaY+50);
	else
		scale = ofGetWidth()/(deltaX+50);
}


void nexAgedLayout2D::setNodeState(int node, float state){
	Physics::Particle *p = physics.getParticle(node);
	((nexNodeData_t *)p->data)->state = state;

}


void nexAgedLayout2D::setNodePos(int node, float x, float y, float z){
	Physics::Particle *p = physics.getParticle(node);
	((nexNodeData_t *)p->data)->pos.x = x;
	((nexNodeData_t *)p->data)->pos.y = y;
	((nexNodeData_t *)p->data)->pos.z = z;
}


void nexAgedLayout2D::setNodeCol(int node, float r, float g, float b, float a){
	Physics::Particle *p = physics.getParticle(node);
	((nexNodeData_t *)p->data)->col.r = r;
	((nexNodeData_t *)p->data)->col.g = g;
	((nexNodeData_t *)p->data)->col.b = b;
	((nexNodeData_t *)p->data)->col.a = a;
}


void nexAgedLayout2D::manualNodePos(bool manualPos){
	manNodePos = manualPos;
}


void nexAgedLayout2D::manualNodeCol(bool manualCol){
	manNodeCol = manualCol;
}


void nexAgedLayout2D::setEdgeState(int source, int target, float state){
	Physics::Spring   *s;
	Physics::Particle *ap = physics.getParticle(source);
	Physics::Particle *bp = physics.getParticle(target);
	
	for (int i=0; i<physics.numberOfSprings(); i++){
		s = physics.getSpring(i);
		if((ap == s->getA() && bp == s->getB()) ||
		   (bp == s->getA() && ap == s->getB())){
			((nexEdgeData_t *)(s->data))->state = state;
		}
	}
}


void nexAgedLayout2D::setEdgeCol(int source, int target, float r, float g, float b, float a){
	Physics::Spring   *s;
	Physics::Particle *ap = physics.getParticle(source);
	Physics::Particle *bp = physics.getParticle(target);
	
	for (int i=0; i<physics.numberOfSprings(); i++){
		s = physics.getSpring(i);
		if((ap == s->getA() && bp == s->getB()) ||
		   (bp == s->getA() && ap == s->getB())){
			((nexEdgeData_t *)(s->data))->col.r = r;
			((nexEdgeData_t *)(s->data))->col.g = g;
			((nexEdgeData_t *)(s->data))->col.b = b;
			((nexEdgeData_t *)(s->data))->col.a = a;
		}
	}
}


void nexAgedLayout2D::manualEdgeCol(bool manualCol){
	manEdgeCol = manualCol;
}


void nexAgedLayout2D::setBackgroundColour(float r, float g, float b){
	defBGCol.r = r;
	defBGCol.g = g;
	defBGCol.b = b;
}


void nexAgedLayout2D::setDefaultNodeColour(float r, float g, float b, float a){
	defNodeCol.r = r;
	defNodeCol.g = g;
	defNodeCol.b = b;
	defNodeCol.a = a;
}


void nexAgedLayout2D::setDefaultEdgeColour(float r, float g, float b, float a){
	defEdgeCol.r = r;
	defEdgeCol.g = g;
	defEdgeCol.b = b;
	defEdgeCol.a = a;
}


void nexAgedLayout2D::setNodeSpacing(float spacing){
	stretch = spacing;
}


void nexAgedLayout2D::setAgeingRate(float rate){
	ageingRate = rate;
}


void nexAgedLayout2D::setLayoutStyle(int newStyle){
	style = (NEX_LAYOUT_STYLE_T)newStyle;
}


void nexAgedLayout2D::setBlendFromColour(float r, float g, float b, float a){
	blendFromCol.r = r;
	blendFromCol.g = g;
	blendFromCol.b = b;
	blendFromCol.a = a;
}


void nexAgedLayout2D::setBlendToColour(float r, float g, float b, float a){
	blendToCol.r = r;
	blendToCol.g = g;
	blendToCol.b = b;
	blendToCol.a = a;
}


void nexAgedLayout2D::outputToEPS(char *filename){
	// Begin writing to EPS
	epsOutput.beginEPS(filename);
	epsOutput.disableCenterRect();
	
	float xMax, xMin, yMin, yMax, x, y, z, indentX, indentY, scaling;
	Physics::Particle *p;
	
	if (physics.numberOfParticles() > 1){
		xMax = 110;
		xMin = -10;
		yMax = 110;
		yMin = -10;
	}
	
	for ( int i = 0; i < physics.numberOfParticles(); i++ )
	{
		p = physics.getParticle( i );
		if (manNodePos) {
			x = ((nexNodeData_t *)(p->data))->pos.x;
			y = ((nexNodeData_t *)(p->data))->pos.y;
		}
		else {
			x = p->getPosition().x;
			y = p->getPosition().y;
		}
		xMax = max( xMax, x );
		xMin = min( xMin, x );
		yMin = min( yMin, y );
		yMax = max( yMax, y );
	}
	
	scaling = scale*0.8*(1.0/stretch);
	indentX = ofGetWidth()*0.1;
	indentY = ofGetHeight()*0.1;
	
	// COPIED FROM DRAW =======================
	// EPS does not support transparency so alpha values ignored
	float newDrag, nodeSize, dR, dG, dB, dA;
		
	for(int i=0; i<physics.numberOfSprings(); i++) {
		Physics::Spring *spring = (Physics::Spring *) physics.getSpring(i);
		
		if(!spring->isDead()){
			Physics::Particle *a = spring->getA();
			Physics::Particle *b = spring->getB();
			
			epsOutput.setLineWidth(((nexEdgeData_t *)(spring->data))->state);
			
			if (manEdgeCol) {
				switch (style) {
					case NEX_LAYOUT_STYLE_STD:
					case NEX_LAYOUT_STYLE_BLEND_AGED:
					case NEX_LAYOUT_STYLE_NO_AGEING:
						epsOutput.setColor((int)((nexEdgeData_t *)(spring->data))->col.r,
									  (int)((nexEdgeData_t *)(spring->data))->col.g,
									  (int)((nexEdgeData_t *)(spring->data))->col.b);							
						break;
						
					case NEX_LAYOUT_STYLE_ALPHA_AGED:
						epsOutput.setColor((int)((nexEdgeData_t *)(spring->data))->col.r,
									  (int)((nexEdgeData_t *)(spring->data))->col.g,
									  (int)((nexEdgeData_t *)(spring->data))->col.b);
						break;
						
					default:
						// Do nothing
						break;
				}
			}
			else {
				switch (style) {
					case NEX_LAYOUT_STYLE_STD:
					case NEX_LAYOUT_STYLE_BLEND_AGED:
					case NEX_LAYOUT_STYLE_NO_AGEING:
						epsOutput.setColor(defEdgeCol.r,defEdgeCol.g,defEdgeCol.b);							
						break;
						
					case NEX_LAYOUT_STYLE_ALPHA_AGED:
						epsOutput.setColor(defEdgeCol.r,defEdgeCol.g,defEdgeCol.b);
						break;
						
					default:
						// Do nothing
						break;
				}
			}
			
			if (manNodePos) {
				epsOutput.line(indentX + ((((nexNodeData_t *)(a->data))->pos.x) - xMin) * scaling *stretch, 
									indentY + ((((nexNodeData_t *)(a->data))->pos.y) - yMin) * scaling *stretch, 
						         indentX + ((((nexNodeData_t *)(b->data))->pos.x) - xMin) * scaling *stretch,
									indentY + ((((nexNodeData_t *)(b->data))->pos.y) - yMin) * scaling *stretch);
			}
			else {
				epsOutput.line(indentX + ((a->getPosition().x) - xMin) * scaling *stretch, 
									indentY + ((a->getPosition().y) - yMin) * scaling *stretch, 
									indentX + ((b->getPosition().x) - xMin) * scaling *stretch,
									indentY + ((b->getPosition().y) - yMin) * scaling *stretch);
			}
		}
	}
	
	// Should really only do this when the blended colours change
	if (style == NEX_LAYOUT_STYLE_BLEND_AGED) {
		dR = blendToCol.r - blendFromCol.r;
		dG = blendToCol.g - blendFromCol.g;
		dB = blendToCol.b - blendFromCol.b;
		dA = blendToCol.a - blendFromCol.a;
	}
	
	for(int i=0; i<physics.numberOfParticles(); i++) {
		p = physics.getParticle(i);
		
		nodeSize = ((nexNodeData_t *)(p->data))->state;
		
		if (manNodePos) {
			x = (((nexNodeData_t *)(p->data))->pos.x - xMin) * scaling;
			y = (((nexNodeData_t *)(p->data))->pos.y - yMin) * scaling;;
		}
		else {
			x =  (p->getPosition().x - xMin) * scaling;
			y =  (p->getPosition().y - yMin) * scaling;
		}
		
		if (manNodeCol) {
			
			switch (style) {
				case NEX_LAYOUT_STYLE_STD:
				case NEX_LAYOUT_STYLE_BLEND_AGED:
				case NEX_LAYOUT_STYLE_NO_AGEING:
					epsOutput.setColor((int)((nexNodeData_t *)(p->data))->col.r,
								  (int)((nexNodeData_t *)(p->data))->col.g,
								  (int)((nexNodeData_t *)(p->data))->col.b);				
					epsOutput.fill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);
					epsOutput.setColor((int)((nexNodeData_t *)(p->data))->col.r*0.8,
								  (int)((nexNodeData_t *)(p->data))->col.g*0.8,
								  (int)((nexNodeData_t *)(p->data))->col.b*0.8);
					epsOutput.setLineWidth(2.0);
					epsOutput.noFill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);							
					break;
					
				case NEX_LAYOUT_STYLE_ALPHA_AGED:
					epsOutput.setColor((int)((nexNodeData_t *)(p->data))->col.r,
								  (int)((nexNodeData_t *)(p->data))->col.g,
								  (int)((nexNodeData_t *)(p->data))->col.b);				
					epsOutput.fill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);
					epsOutput.setColor((int)((nexNodeData_t *)(p->data))->col.r*0.8,
								  (int)((nexNodeData_t *)(p->data))->col.g*0.8,
								  (int)((nexNodeData_t *)(p->data))->col.b*0.8);
					epsOutput.setLineWidth(2.0);
					epsOutput.noFill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);
					break;
					
				default:
					// Do nothing
					break;
			}	
		}
		else {
			
			switch (style) {
				case NEX_LAYOUT_STYLE_STD:
				case NEX_LAYOUT_STYLE_NO_AGEING:
					epsOutput.setColor(defNodeCol.r,defNodeCol.g,defNodeCol.b);
					epsOutput.fill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);
					epsOutput.setColor(defNodeCol.r*0.8,defNodeCol.g*0.8,defNodeCol.b*0.8);
					epsOutput.setLineWidth(2.0);
					epsOutput.noFill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);							
					break;
					
				case NEX_LAYOUT_STYLE_ALPHA_AGED:
					epsOutput.setColor(defNodeCol.r,defNodeCol.g,defNodeCol.b);				
					epsOutput.fill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);
					epsOutput.setColor(defNodeCol.r*0.8,defNodeCol.g*0.8,defNodeCol.b*0.8);
					epsOutput.setLineWidth(2.0);
					epsOutput.noFill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);
					break;
					
				case NEX_LAYOUT_STYLE_BLEND_AGED:
					epsOutput.setColor(blendFromCol.r+(dR*p->getDrag()),
								  blendFromCol.g+(dG*p->getDrag()),
								  blendFromCol.b+(dB*p->getDrag()));				
					epsOutput.fill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);
					epsOutput.setColor(blendFromCol.r+(dR*p->getDrag())*0.8,
								  blendFromCol.g+(dG*p->getDrag())*0.8,
								  blendFromCol.b+(dB*p->getDrag())*0.8);
					epsOutput.setLineWidth(2.0);
					epsOutput.noFill();
					epsOutput.circle(indentX + x*stretch, indentY + y*stretch, nodeSize*scaling);
					break;
					
				default:
					// Do nothing
					break;
			}	
		}
	}

	// END COPY =======================
	
	// End writing to EPS
	epsOutput.endEPS();
}

