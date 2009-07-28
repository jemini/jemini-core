require 'managers/input_support/input_message'

module Gemini
  class InputMapping
    attr_accessor :device, :input_type, :input_button_or_axis, :joystick_id, :destination_type, :destination_value, :input_callback

    def self.create(device, options, &callback)
      options[:input_callback] = callback
      type =  case device
              when :key
                ::Gemini::KeyMapping
              when :mouse
                ::Gemini::MouseMapping
              when :joystick
                ::Gemini::JoystickMapping
              end
      type.new(options)
    end

    # TODO: Indicate whether or not a joystick mapping is active if a joystick is not installed
    def initialize(options)
      options = options.dup # we're going to delete some entries, which could have odd side effects without a clone
      @input_type = [:held, :released, :pressed, :axis_update].find do |input_event_name|
                      input_event_button_or_axis = options.delete input_event_name
                      if input_event_button_or_axis.nil?
                        false
                      else
                        @input_button_or_axis = input_event_button_or_axis
                        true
                      end
                    end

      @joystick_id    = options.delete(:joystick_id)
      @input_callback = options.delete(:input_callback)
      @player         = options.delete :player
      # after all the deletes, the game message and value should be only what's left
      @game_message   = options.keys.first
      @game_value     = options.values.first
    end

    def poll(raw_input)
      @poll_result = poll_value(raw_input)
      if post_canceled?
        @cancel_post = false
        nil
      else
        to_game_message(raw_input, @poll_result)
      end
    end

    def cancel_post!
      @cancel_post = true
    end

    def post_canceled?
      @cancel_post
    end

    def key
      "#{@device}_#{@input_type}_#{@input_button_or_axis}_#{@joystick_id || 'any'}"
    end

    def to_s
      key
    end

    # eventually, raw_input will need to be wrapped
    def to_game_message(raw_input, game_value)
      game_message = InputMessage.new(@game_message, game_value)
      game_message.player = @player
      @input_callback.call(game_message, raw_input) unless @input_callback.nil?
      game_message
    end
  end
end