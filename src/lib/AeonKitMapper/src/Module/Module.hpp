//
//  Module.hpp
//  AeonNodeEditor
//
//  Created by Akira Matsuda on 3/10/16.
//
//

#ifndef Module_hpp
#define Module_hpp

#include <string>
#include <vector>
#include "ofEventUtils.h"
#include "ofxDatGui.h"
#include "ModuleCore.hpp"
#include "thunderclap.h"

namespace AeonKitMapper {
	template <typename T> class Module : public ModuleCore {
	protected:
		ofxDatGui *gui;
		
		virtual void onMouseDragged(ofMouseEventArgs& mouseArgs) override;
	public:
		virtual void connected(AeonNode::Connector *to) override {
			this->eval_and_send();
		}
		virtual void size_to_fit() override;
		void update(ofEventArgs &args);
		Module(std::string module_name, float x, float y);
		~Module();
		virtual void add_connector(std::string tag, std::type_info *connectable_type, AeonNode::Connector::Type type) override;
		virtual void received_data(AeonNode::Node *from, AeonNode::Connector *connector, boost::any data) override = 0;
		virtual T eval() = 0;
		virtual void eval_and_send() = 0;
		virtual T update_output_state() = 0;
	};
}

namespace AeonKitMapper {
	template <typename T> void Module<T>::onMouseDragged(ofMouseEventArgs& mouseArgs) {
		Node::onMouseDragged(mouseArgs);
		if (this->selected) {
			this->gui->setPosition(this->frame.origin.x, this->frame.origin.y);
		}
	}
	
	template <typename T> void Module<T>::size_to_fit() {
		Node::size_to_fit();
		this->frame.size.height = this->gui->getHeight() - 3;
	}
	
	template <typename T> void Module<T>::update(ofEventArgs &args) {
		this->gui->update();
	}
	
	template <typename T> Module<T>::Module(std::string module_name, float x, float y) : ModuleCore(module_name, x, y) {
		this->did_draw = [=] (ofxHierarchy::Rect frame) {
			this->gui->draw();
		};
		
		this->gui = new ofxDatGui(ofxDatGuiAnchor::NO_ANCHOR);
		this->gui->setPosition(this->frame.origin.x, this->frame.origin.y);
		this->gui->setWidth(150, 20);
		this->gui->addHeader(this->module_name, false);
		this->size_to_fit();
		
		ofAddListener(ofEvents().update, this, &Module::update);
	}
	
	template <typename T> Module<T>::~Module() {
		delete this->gui;
	}
	
	template <typename T> void Module<T>::add_connector(std::string tag, std::type_info *connectable_type, AeonNode::Connector::Type type) {
		this->size_to_fit();
		ModuleCore::add_connector(tag, connectable_type, type);
	}
}


//#include "detail/Module.hpp"

#endif /* Module_hpp */
