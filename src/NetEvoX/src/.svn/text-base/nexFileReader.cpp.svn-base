
#include "ofMain.h"
#include <pthread.h>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

#include <mach/semaphore.h>
#include <mach/task.h>

#include "nexFileReader.h"

extern int evoDelay;
extern int dynDelay;
extern semaphore_t updateSem;

// REMOVE: ANALYSIS
#ifdef ANALYSIS
FILE *fMove = NULL;
#endif

using namespace std;
template <class T>
bool from_string(T& t, 
                 const std::string& s, 
                 std::ios_base& (*f)(std::ios_base&))
{
	std::istringstream iss(s);
	return !(iss >> f >> t).fail();
}


std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems){
    std::stringstream ss(s);
    std::string item;
    while(std::getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}


std::vector<std::string> split(const std::string &s, char delim){
    std::vector<std::string> elems;
    return split(s, delim, elems);
}



nexFileReader::nexFileReader(nexLayout *newLayout, char *newFile){
	playing = false;
	layout  = newLayout;
	strcpy(theFile, newFile);
	myfile = NULL;
	ofxThread();
}


void nexFileReader::threadedFunction(){
	readFile(theFile);
}


void nexFileReader::startReading(){
	playing = true;
	startThread(true, false);
}

char * nexFileReader::getFilename(){
	return theFile;
}


void nexFileReader::readFile(char *filename){
	vector<string> elements;
	int node, i, j;
	float state, x, y, z, r, g, b, a;
	string line;
	string token;
	
#ifdef ANALYSIS
	// REMOVE: ANALYSIS
	fMove = fopen("/Users/enteg/Desktop/Analysis.csv", "w");
#endif
	
	myfile = new ifstream(filename);
	if (myfile != NULL && myfile->is_open())
	{
		while (myfile != NULL && !myfile->eof())
		{
			lock();
			getline (*myfile,line);
			
			// Split the line into components
			elements = split(line, ',');
			if(elements.size() > 0){
				
				token = elements.at(0);
				
				// Logic to handle the loading of elements
				if(token == "N+"){
					// Add a new node
					semaphore_wait(updateSem);
					layout->addNode();
					semaphore_signal(updateSem);
				}
				else if(token == "E+"){
					// Add an edge if the next 2 tokens exist
					if (elements.size() > 2){
						from_string<int>(i, elements.at(1), std::dec);
						from_string<int>(j, elements.at(2), std::dec);
						semaphore_wait(updateSem);
						layout->addEdge(i, j);
						semaphore_signal(updateSem);
					}
				}
				else if(token == "N-"){
					// Remove a node if the next token exists
					if (elements.size() > 1){
						from_string<int>(i, elements.at(1), std::dec);
						semaphore_wait(updateSem);
						layout->removeNode(i);
						semaphore_signal(updateSem);
					}
				}
				else if(token == "E-"){
					// Add an edge if the next 2 tokens exist
					if (elements.size() > 2){
						from_string<int>(i, elements.at(1), std::dec);
						from_string<int>(j, elements.at(2), std::dec);
						semaphore_wait(updateSem);
						layout->removeEdge(i, j);
						semaphore_signal(updateSem);
					}
				}
				else if(token == "NS1"){
					// Update single node state
					if (elements.size() > 2){
						from_string<int>(i, elements.at(1), std::dec);
						from_string<float>(state, elements.at(2), std::dec);
						semaphore_wait(updateSem);
						layout->setNodeState(i, state);
						semaphore_signal(updateSem);
					}
				}
				else if(token == "NS"){
					// Update all node state
					if (elements.size() > 1){
						for(node=1; node<elements.size(); node++){
							from_string<float>(state, elements.at(node), std::dec);
							semaphore_wait(updateSem);
							layout->setNodeState(node-1, state);
							semaphore_signal(updateSem);
						}
					}
				}
				else if(token == "ES1"){
					// Update single edge state
					if (elements.size() > 3){
						from_string<int>(i, elements.at(1), std::dec);
						from_string<int>(j, elements.at(2), std::dec);
						from_string<float>(state, elements.at(3), std::dec);
						semaphore_wait(updateSem);
						layout->setEdgeState(i, j, state);
						semaphore_signal(updateSem);
					}
				}
				else if(token == "NP"){
					// Update single node position
					if (elements.size() > 4){
						from_string<int>(i, elements.at(1), std::dec);
						from_string<float>(x, elements.at(2), std::dec);
						from_string<float>(y, elements.at(3), std::dec);
						from_string<float>(z, elements.at(4), std::dec);
						semaphore_wait(updateSem);
						layout->setNodePos(i, x, y, z);
						semaphore_signal(updateSem);
					}
				}
				else if(token == "NC"){
					// Update single node colour
					if (elements.size() > 5){
						from_string<int>(i, elements.at(1), std::dec);
						from_string<float>(r, elements.at(2), std::dec);
						from_string<float>(g, elements.at(3), std::dec);
						from_string<float>(b, elements.at(4), std::dec);
						from_string<float>(a, elements.at(5), std::dec);
						semaphore_wait(updateSem);
						layout->setNodeCol(i, r, g, b, a);
						semaphore_signal(updateSem);
					}
				}
				else if(token == "EC"){
					// Update single edge colour
					if (elements.size() > 6){
						from_string<int>(i, elements.at(1), std::dec);
						from_string<int>(j, elements.at(2), std::dec);
						from_string<float>(r, elements.at(3), std::dec);
						from_string<float>(g, elements.at(4), std::dec);
						from_string<float>(b, elements.at(5), std::dec);
						from_string<float>(a, elements.at(6), std::dec);
						semaphore_wait(updateSem);
						layout->setEdgeCol(i, j, r, g, b, a);
						semaphore_signal(updateSem);
					}
				}
				else if(token == "--"){
					ofSleepMillis(evoDelay);
					semaphore_wait(updateSem);
					layout->step();
#ifdef ANALYSIS
					// REMOVE: ANALYSIS
					fprintf(fMove, "\n");
#endif
					semaphore_signal(updateSem);
				}
				else if(token == "-"){
					ofSleepMillis(dynDelay);
				}
				else if(token == "T-"){
					// Update dynDelay time (milliseconds)
					if (elements.size() > 1){
						from_string<int>(i, elements.at(1), std::dec);
						if (i > 0) {
							dynDelay = i;
						}
					}
				}
				else if(token == "T--"){
					// Update evoDelay time (milliseconds)
					if (elements.size() > 1){
						from_string<int>(i, elements.at(1), std::dec);
						if (i > 0) {
							evoDelay = i;
						}
					}
				}
				else if(token == "LAYOUT-CUSTOM"){
					// User specified node locations
					layout->manualNodePos(true);
				}
				else if(token == "NODE-COLOURS-CUSTOM"){
					// Custom node colours
					layout->manualNodeCol(true);
				}
				else if(token == "EDGE-COLOURS-CUSTOM"){
					// Custom edge colours
					layout->manualEdgeCol(true);
				}
				else {
					cout << "[NetEvoX] Unknown token found in file: " << token << "\n"; 
				}
			}
			unlock();
		}
		myfile->close();

#ifdef ANALYSIS
		// REMOVE: ANALYSIS
		fclose(fMove);
#endif
	}
	else{ 
		cout << "[NetEvoX] Unable to open file: " << filename << "\n"; 
	}
}


void nexFileReader::stop(){
	if (myfile != NULL){
		myfile->close();
	}
	stopThread();
}
