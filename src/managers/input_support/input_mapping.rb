module Gemini
  class InputMapping
    attr_accessor :device, :input_type, :input_button_or_axis, :joystick_id, :destination_type, :destination_value, :input_callback

    def self.create(device, options, &callback)
      options[:input_callback] = callback
      new(device, options)
    end

    # TODO: Indicate whether or not a joystick mapping is active if a joystick is not installed
    def initialize(device, options)
      options = options.dup # we're going to delete some entries, which could have odd side effects without a clone
      @device = device
      @input_type = [:held, :released, :pressed, :axis_update].find do |input_event_name|
                      input_event_button_or_axis = options.delete input_event_name
                      if input_event_button_or_axis.nil?
                        false
                      else
                        @input_button_or_axis = input_event_button_or_axis
                        true
                      end
                    end

      @joystick_id = options.delete(:joystick_id)
      @input_callback = options.delete(:input_callback)
      # after all the deletes, the game message and value should be only what's left
      @game_message = options.keys.first
      @game_value   = options.values.first
    end

    def poll(raw_input)
      @game_value = case @device
                    when :key
                      poll_key(raw_input)
                    when :mouse
                    when :joystick
                      poll_joystick(raw_input)
                    end
      if post_canceled?
        nil
      else
        to_game_message(raw_input)
      end
    end

    def poll_key(raw_input)
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

    def poll_joystick(raw_input)
      case @input_type
      when :axis_update
        @axis_id ||= find_axis_id_by_axis_name(raw_input, @input_button_or_axis)
        axis_value = raw_input.get_axis_value(@joystick_id, @axis_id)
        axis_value
      when :held
        result = raw_input.is_button_pressed(@input_button_or_axis, @joystick_id)
        cancel_post! unless result
        result
      else
        cancel_post!
      end
    end

    def cancel_post!
      @cancel_post = true
    end

    def post_canceled?
      result = @cancel_post
      @cancel_post = false
      result
    end

    def find_axis_id_by_axis_name(raw_input, axis_name)
      (0..raw_input.get_axis_count(@joystick_id)).find {|axis_id| raw_input.get_axis_name(@joystick_id, axis_id) == axis_name}
    end

    def key
      "#{@device}_#{@input_type}_#{@input_button_or_axis}_#{@joystick_id}"
    end
    
    # eventually, raw_input will need to be wrapped
    def to_game_message(raw_input)
      game_message = Message.new(@game_message, @game_value)
      @input_callback.call(game_message, raw_input) unless @input_callback.nil?
      game_message
    end
  end
end