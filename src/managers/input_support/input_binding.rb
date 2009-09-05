require 'managers/input_support/input_listener'

module Jemini
  class InputBinding
    MOUSE_BUTTON_NAMES = [:mouse_left, :mouse_right, :mouse_middle].freeze
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
      if mouse_button?(button_id)
        :mouse
      else
        :key
      end
    end

    def detect_button(button_id, device)
      case device
      when :mouse
        detect_mouse_button(button_id)
      when :key
        #TODO: translate button ids from friendly form to something that works for the Input class
        #"Input::KEY_#{button_id.to_s.upcase}".constantize
        button_id
      end
    end

    def mouse_button?(button_id)
      return true if MOUSE_BUTTON_NAMES.include? button_id
      return false unless button_id.respond_to? :has_key?
      return true if button_id.has_key? :mouse_button
    end

    def detect_mouse_button(button_id)
      case button_id
      when :mouse_left
        1
      when :mouse_right
        2
      when :mouse_middle
        3
      else
        button_id[:mouse_button]
      end
    end
  end
end