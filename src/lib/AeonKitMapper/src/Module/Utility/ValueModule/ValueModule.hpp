//
//  ValueModule.hpp
//  AeonNodeEditor
//
//  Created by Akira Matsuda on 3/13/16.
//
//

#ifndef ValueModule_hpp
#define ValueModule_hpp

#include "Module.hpp"

namespace AeonKitMapper {
	template <typename T> class ValueModule : public Module<T> {
	private:
		T value;
		void onSliderEvent(ofxDatGuiSliderEvent e);
	public:
		ValueModule(float x, float y);
		virtual void set_value(T value) {
			this->value = value;
		};
		virtual void received_data(AeonNode::Node *from, AeonNode::Connector *connector, boost::any data) override {};
		virtual T eval() override;
		virtual void eval_and_send() override;
		virtual T update_output_state() override;
	};
}

//#include "detail/ValueModule.hpp"

namespace AeonKitMapper {
	template <typename T> ValueModule<T>::ValueModule(float x, float y) : Module<T>("Value", x, y) {
		this->add_connector("output", (std::type_info *)&typeid(T), AeonNode::Connector::Type::Output);
		ofxDatGuiSlider *slider = this->gui->addSlider("value", 0, 255);
		slider->onSliderEvent(this,& ValueModule::onSliderEvent);
		slider->bind(this->value, 0, 255);
	}
	
	template <typename T> void ValueModule<T>::onSliderEvent(ofxDatGuiSliderEvent e) {
		this->eval_and_send();
	}
	
	template <typename T> T ValueModule<T>::eval() {
		return this->value;
	}
	
	template <typename T> void ValueModule<T>::eval_and_send() {
		this->send_data(this->update_output_state());
	}
	
	template <typename T> T ValueModule<T>::update_output_state() {
		return this->eval();
	}
}

#endif /* ValueModule_hpp */
