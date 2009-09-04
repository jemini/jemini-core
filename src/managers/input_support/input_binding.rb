require 'managers/input_support/input_listener'

module Jemini
  class InputBinding
    attr_reader :action_name, :listeners

    def initialize(action_name)
      @action_name = action_name
      @listeners = []
    end

    def add_input_listener(button_type, button_id)
      device      = detect_device(button_id)
      real_button = detect_button(button_id, device)
      listener    = InputListener.create(action_name, button_type, device, real_button)
      Jemini::BaseState.active_state.manager(:input).listeners << listener
#      @listeners << 
    end

    def detect_device(button_id)
      case button_id
      when :mouse_left
        :mouse
      else
        :key
      end
    end

    def detect_button(button_id, device)
      case device
      when :mouse
        case button_id
        when :mouse_left
          1
        when :mouse_right
          2
        when :mouse_middle
          3
        end
      when :key
        #TODO: translate button ids from friendly form to something that works for the Input class
        #"Input::KEY_#{button_id.to_s.upcase}".constantize
        button_id
      end
    end
  end
end