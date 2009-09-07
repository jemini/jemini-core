require 'managers/input_support/input_listener'

module Jemini
  class MouseListener < Jemini::InputListener
    def device
      :mouse
    end

    def poll_value(raw_input)
      value                 = MouseValue.new
      value.position        = percent_on_screen(raw_input)
      value.screen_position = Vector.new(raw_input.mouse_x, raw_input.mouse_y)
      case @input_type
      when :move, :axis_update
        
      when :press
        cancel_post! unless raw_input.mouse_pressed?(@input_button_or_axis)
      when :hold
        begin
        cancel_post! unless raw_input.mouse_button_down?(@input_button_or_axis)
        rescue => e
          puts e
          puts e.backtrace
        end
      when :release
        button_down = raw_input.mouse_button_down?(@input_button_or_axis)
        result = (@button_down_on_last_poll && !button_down)
        @button_down_on_last_poll = button_down
        cancel_post! unless result
      end

      value
    end

    def percent_on_screen(raw_input)
      Vector.new(raw_input.mouse_x.to_f / game_state.screen_size.x.to_f, raw_input.mouse_y.to_f / game_state.screen_size.y.to_f)
    end
  end

  class MouseValue
    attr_accessor :position, :screen_position, :position_delta, :screen_position_delta
  end
end