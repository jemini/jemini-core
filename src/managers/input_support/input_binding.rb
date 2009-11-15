require 'managers/input_support/input_listener'

module Jemini
  class InputBinding
    MOUSE_BUTTON_NAMES = [:mouse_left, :mouse_right, :mouse_middle].freeze
    attr_reader :action_name, :listeners

    def initialize(action_name)
      @action_name = action_name
      @listeners   = []
    end

    # type can be one of :hold, :release, :press, and :move
    def add_input_listener(type, button_id, options={})
      device                 = detect_device(button_id, type)
      real_button            = detect_button(button_id, options, device)
      value                  = options[:value]
      to                     = options[:to]
      id                     = options[:id]
      listener               = InputListener.create(action_name, type, device, real_button)
      listener.default_value = value
      listener.message_to    = to
      listener.joystick_id   = id
      listener.axis_inverted = options[:invert]
      listener.deadzone      = options[:deadzone]
      InputManager.loading_input_manager.listeners << listener
    end

    def detect_device(button_id, type)
      if mouse_button?(button_id, type)
        :mouse
      elsif joystick_button?(button_id, type)
        :joystick
      else
        :key
      end
    end

    def detect_button(button_id, options, device)
      case device
      when :mouse
        detect_mouse_button(button_id)
      when :joystick
        detect_joystick_button(button_id, options)
      when :key
        case button_id.to_s
        when /(left|right)_alt/
          "Input::KEY_#{$1[0].chr.upcase}ALT".constantize
        when /(left|right)_ctrl/
          "Input::KEY_#{$1[0].chr.upcase}CONTROL".constantize
        when /(left|right)_bracket/
          "Input::KEY_#{$1[0].chr.upcase}BRACKET".constantize
        when /(up|down|left|right)_arrow/
          "Input::KEY_#{$1.upcase}".constantize
        when /(left|right)_shift/
          "Input::KEY_#{$1[0].chr.upcase}SHIFT".constantize
        else
          "Input::KEY_#{button_id.to_s.underscore.upcase}".constantize
        end
      end
    end

    def mouse_button?(button_id, type)
      return true if type == :move && button_id == :mouse
      return true if MOUSE_BUTTON_NAMES.include? button_id
      return false unless button_id.respond_to? :has_key?
      return true if button_id.has_key? :mouse_button
    end

    def joystick_button?(button_id, type)
      return true if button_id == :joystick
#      return true if type == :move && button_id == :joystick
#      return false unless button_id.respond_to? :has_key?
#      return true if button_id.has_key? :joystick_button
#      return true if button_id.has_key? :joystick_button
    end

    def detect_joystick_button(button_id, options)
      options[:button] || options[:axis]
    end

    def detect_mouse_button(button_id)
      case button_id
      when :mouse_left
        0
      when :mouse_right
        1
      when :mouse_middle
        2
      when :mouse
        nil
      else
        button_id[:mouse_button]
      end
    end
  end
end