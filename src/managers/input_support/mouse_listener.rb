require 'managers/input_support/input_listener'

module Jemini
  class MouseListener < Jemini::InputListener
    def device
      :mouse
    end

    def poll_value(raw_input)
      value = MouseValue.new
      value.pointer = Vector.new(raw_input.mouse_x, raw_input.mouse_y)
      case @input_type
      when :axis_update, :move
        
      when :press
        cancel_post! unless raw_input.mouse_pressed?(@input_button_or_axis)
      when :hold
        cancel_post! unless raw_input.mouse_button_down?(@input_button_or_axis)
      when :release
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