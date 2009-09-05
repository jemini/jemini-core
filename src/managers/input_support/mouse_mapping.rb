require 'managers/input_support/input_mapping'

module Jemini
  class MouseMapping < Jemini::InputMapping
    def device
      :mouse
    end

    def poll_value(raw_input)
      value = MouseValue.new
      value.pointer = Vector.new(raw_input.mouse_x, raw_input.mouse_y)
      case @input_type
      when :axis_update, :move
        
      when :pressed
        cancel_post! unless raw_input.mouse_pressed?(@input_button_or_axis)
      when :held
        cancel_post! unless raw_input.mouse_button_down?(@input_button_or_axis)
      when :released
        button_down = raw_input.mouse_button_down?(@input_button_or_axis)
        result = (@button_down_on_last_poll && !button_down)
        @button_down_on_last_poll = button_down
        cancel_post! unless result
      end

      value
    end
  end

  class MouseValue
    attr_accessor :pointer, :pointer_delta
  end
end