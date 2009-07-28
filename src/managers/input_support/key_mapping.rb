require 'managers/input_support/input_mapping'

module Gemini
  class KeyMapping < Gemini::InputMapping
    def device
      :key
    end

    def poll_value(raw_input)
      case @input_type
      when :pressed
        result = raw_input.is_key_pressed(@input_button_or_axis)
        cancel_post! unless result
        result
      when :held
        result = raw_input.is_key_down(@input_button_or_axis)
        cancel_post! unless result
        result
      when :released
        key_down = raw_input.is_key_down(@input_button_or_axis)
        result = (@key_down_on_last_poll && !key_down) ? true : false
        @key_down_on_last_poll = key_down
        cancel_post! unless result
        result
      else
        cancel_post!
      end
    end
  end
end