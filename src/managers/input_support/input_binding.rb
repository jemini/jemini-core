require 'managers/input_support/input_listener'

module Jemini
  class InputBinding
    attr_reader :action_name, :listeners

    def initialize(action_name)
      @action_name = action_name
      @listeners = []
    end

    def add_input_listener(button_type, button_id)
      listener = InputListener.create(action_name, button_type, detect_device(button_id), button_id)
      Gemini::BaseState.active_state.manager(:input).listeners << listener
#      @listeners << 
    end

    def detect_device(button_id)
      :key
    end
  end
end