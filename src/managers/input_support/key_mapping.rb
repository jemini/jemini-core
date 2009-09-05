require 'managers/input_support/input_mapping'

module Jemini
  class KeyMapping < Jemini::InputMapping
    def device
      :key
    end

    def poll_value(raw_input)
      case @input_type
      when :pressed
        cancel_post! unless raw_input.is_key_pressed(@input_button_or_axis)
      when :held
        cancel_post! unless raw_input.is_key_down(@input_button_or_axis)
      when :released
        key_down = raw_input.is_key_down(@input_button_or_axis)
        result = (@key_down_on_last_poll && !key_down) ? true : false
        @key_down_on_last_poll = key_down
        cancel_post! unless result
      else
        cancel_post!
      end
      @game_value unless post_canceled?
    end
  end
end