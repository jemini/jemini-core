require 'managers/input_support/input_listener'

module Jemini
  class JoystickListener < Jemini::InputListener
    def device
      :joystick
    end

    def find_axis_id_by_axis_name(raw_input, axis_name)
      (0..raw_input.get_axis_count(@joystick_id)).find {|axis_id| raw_input.get_axis_name(@joystick_id, axis_id) == axis_name}
    end
    
    def poll_value(raw_input)
      if @joystick_id && @joystick_id >= raw_input.controller_count
        cancel_post!
        return
      end

      case @input_type
      when :axis_update
        @axis_id ||= find_axis_id_by_axis_name(raw_input, @input_button_or_axis)
        axis_value = raw_input.get_axis_value(@joystick_id, @axis_id)
        axis_value
      when :pressed
        if @joystick_id.nil?
          result = (0..raw_input.controller_count).any? {|i| raw_input.is_button_pressed(@input_button_or_axis, i)} unless raw_input.controller_count.zero?
        else
          result = raw_input.is_button_pressed(@input_button_or_axis, @joystick_id)
        end
        pressed = !@key_down_on_last_poll && result
        @key_down_on_last_poll = result
        cancel_post! unless pressed
        pressed
      when :held
        if @joystick_id.nil?
          result = (0..raw_input.controller_count).any? {|i| raw_input.is_button_pressed(@input_button_or_axis, i)} unless raw_input.controller_count.zero?
        else
          result = raw_input.is_button_pressed(@input_button_or_axis, @joystick_id)
        end
        cancel_post! unless result
        result
      when :released
        button_down = raw_input.is_button_pressed(@input_button_or_axis, @joystick_id)
        result = (@key_down_on_last_poll && !button_down) ? true : false
        @key_down_on_last_poll = button_down
        cancel_post! unless result
        result
      else
        cancel_post!
      end
    end
  end
end