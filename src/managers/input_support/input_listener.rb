require 'managers/input_support/input_message'

module Jemini
  class InputListener
    attr_accessor :device,
                  :input_type,
                  :input_button_or_axis,
                  :joystick_id,
                  :destination_type,
                  :destination_value,
                  :input_callback,
                  :game_state,
                  :default_value,
                  :message_to,
                  :axis_inverted,
                  :deadzone

    def self.create(message, type, device, button_id, options={}, &callback)
      options[:input_callback] = callback
      device_type =  case device
                     when :key
                       KeyListener
                     when :mouse
                       MouseListener
                     when :joystick
                       JoystickListener
                     end
      device_type.new(message, type, button_id, options)
    end

    # TODO: Indicate whether or not a joystick mapping is active if a joystick is not installed
    def initialize(message, button_type, button_id, options)
      @input_type     = button_type
      @input_button_or_axis = button_id
      @game_message   = message
      # TODO: There has to be a better, threadsafe way to do this.
      # Maybe threadsafety isn't a huge concern here?
      @game_state     = Jemini::InputManager::loading_input_manager.game_state
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

    def axis_inverted?
      @axis_inverted
    end

    def key
      "#{@device}_#{@input_type}_#{@input_button_or_axis}_#{@joystick_id || 'any'}"
    end

    def to_s
      key
    end

    # eventually, raw_input will need to be wrapped
    def to_game_message(raw_input, game_value)
      game_message = InputMessage.new(@game_message, default_value || game_value)
      game_message.player = @player
      @input_callback.call(game_message, raw_input) unless @input_callback.nil?
      game_message.to = message_to
      game_message
    end
  end
end