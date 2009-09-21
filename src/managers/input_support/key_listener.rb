require 'managers/input_support/input_listener'

module Jemini
  class KeyListener < Jemini::InputListener
    def device
      :key
    end

    def poll_value(raw_input)
      case @input_type
      when :press
        cancel_post! unless raw_input.is_key_pressed(@input_button_or_axis)
      when :hold
        cancel_post! unless raw_input.is_key_down(@input_button_or_axis)
      when :release
        key_down = raw_input.is_key_down(@input_button_or_axis)
        result = (@key_down_on_last_poll && !key_down) ? true : false
        @key_down_on_last_poll = key_down
        cancel_post! unless result
      else
        cancel_post!
        raise "Input type of #{@input_type.inspect} is not supported!"
      end
      @game_value unless post_canceled?
    end
  end
end
