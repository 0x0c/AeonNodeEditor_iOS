#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	ofSetBackgroundColor(0, 0, 0, 255);
	this->view.frame = ofxHierarchy::Rect({0, 0, (float)ofGetWidth(), (float)ofGetHeight()});
	
	this->gui = new ofxDatGui();
	this->gui->setWidth(200);
	
	auto export_button = this->gui->addButton("Export");
	export_button->onButtonEvent(this, &ofApp::onExportButtonEvent);
	
	auto folder = this->gui->addFolder("Logic Modules");
	std::vector<std::string> modules = {"Boolean", "Not", "AND", "OR", "XOR"};
	for (int i = 0; i < modules.size(); i++) {
		auto button = folder->addButton(modules[i]);
		button->onButtonEvent(this, &ofApp::onAddModuleButtonEvent);
		button->setTheme(new ofxDatGuiThemeAqua());
	}
	
	folder = this->gui->addFolder("Utility Modules");
	modules = {"HapticPattern", "Counter", "Value_Int", "StringConverter_Int", "StringConverter_Float", "StringConverter_Bool"};
	for (int i = 0; i < modules.size(); i++) {
		auto button = folder->addButton(modules[i]);
		button->onButtonEvent(this, &ofApp::onAddModuleButtonEvent);
		button->setTheme(new ofxDatGuiThemeAqua());
	}
	
	folder = this->gui->addFolder("Condition Modules");
	modules = {"Condition_Int", "Condition_Bool"};
	for (int i = 0; i < modules.size(); i++) {
		auto button = folder->addButton(modules[i]);
		button->onButtonEvent(this, &ofApp::onAddModuleButtonEvent);
		button->setTheme(new ofxDatGuiThemeAqua());
	}
	
	folder = this->gui->addFolder("Display Modules");
	modules = {"OLED", "Haptic"};
	for (int i = 0; i < modules.size(); i++) {
		auto button = folder->addButton(modules[i]);
		button->onButtonEvent(this, &ofApp::onAddModuleButtonEvent);
		button->setTheme(new ofxDatGuiThemeAqua());
	}
	
	folder = this->gui->addFolder("Sensor Modules");
	modules = {"Depth", "Tilt", "Touch"};
	for (int i = 0; i < modules.size(); i++) {
		auto button = folder->addButton(modules[i]);
		button->onButtonEvent(this, &ofApp::onAddModuleButtonEvent);
		button->setTheme(new ofxDatGuiThemeAqua());
	}
	
	AeonKitMapper::ModuleImporter::import(&this->view, &this->modules);
}

//--------------------------------------------------------------
void ofApp::update(){
	this->gui->update();
}

//--------------------------------------------------------------
void ofApp::draw(){
	this->gui->draw();
	this->view.draw();
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
	if (key == 'f') {
		ofToggleFullscreen();
	}
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){}

void ofApp::onExportButtonEvent(ofxDatGuiButtonEvent e) {
	AeonKitMapper::ModuleExporter::export_module_relation(this->modules);
}

float offset = 50;
void ofApp::onAddModuleButtonEvent(ofxDatGuiButtonEvent e) {
	AeonNode::Node *node = nullptr;
	std::string label = e.target->getLabel();
	if (label == "BOOLEAN") {
		node = new AeonKitMapper::LogicBooleanModule(offset, offset);
	}
	else if (label == "NOT") {
		node = new AeonKitMapper::LogicNOTModule(offset, offset);
	}
	else if (label == "AND") {
		node = new AeonKitMapper::LogicANDModule(offset, offset);
	}
	else if (label == "OR") {
		node = new AeonKitMapper::LogicORModule(offset, offset);
	}
	else if (label == "XOR") {
		node = new AeonKitMapper::LogicXORModule(offset, offset);
	}
	else if (label == "HAPTICPATTERN") {
		node = new AeonKitMapper::HapticPatternGeneratorModule(offset, offset);
	}
	else if (label == "COUNTER") {
		node = new AeonKitMapper::CounterModule(offset, offset);
	}
	else if (label == "STRINGCONVERTER_INT") {
		node = new AeonKitMapper::StringConverterModule<int>(offset, offset);
	}
	else if (label == "VALUE_INT") {
		node = new AeonKitMapper::ValueModule<int>(offset, offset);
	}
	else if (label == "VALUE_FLOAT") {
		node = new AeonKitMapper::ValueModule<float>(offset, offset);
	}
	else if (label == "STRINGCONVERTER_FLOAT") {
		node = new AeonKitMapper::StringConverterModule<float>(offset, offset);
	}
	else if (label == "STRINGCONVERTER_BOOL") {
		node = new AeonKitMapper::StringConverterModule<bool>(offset, offset);
	}
	else if (label == "CONDITION_INT") {
		node = new AeonKitMapper::ConditionModule<int>(offset, offset);
	}
	else if (label == "CONDITION_FLOAT") {
		node = new AeonKitMapper::ConditionModule<float>(offset, offset);
	}
	else if (label == "CONDITION_BOOL") {
		node = new AeonKitMapper::ConditionModule<bool>(offset, offset);
	}
	else if (label == "OLED") {
		node = new AeonKitMapper::OLEDDisplay(offset, offset);
	}
	else if (label == "HAPTIC") {
		node = new AeonKitMapper::HapticDisplay(offset, offset);
	}
	else if (label == "DEPTH") {
		node = new AeonKitMapper::DepthSensor(offset, offset);
	}
	else if (label == "TILT") {
		node = new AeonKitMapper::TiltSensor(offset, offset);
	}
	else if (label == "TOUCH") {
		node = new AeonKitMapper::TouchSensor(offset, offset);
	}
	
	if (node != nullptr) {
		this->modules.push_back(node);
		this->view.add_subview(node);
		offset = node->getMaxY();
	}
}
