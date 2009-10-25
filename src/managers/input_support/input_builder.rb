require 'managers/input_support/input_binding'
require 'logger_mixin'

module Jemini
  class InputBuilder
    
    include LoggerMixin
    
    def self.declare
      yield new
    end

    def in_order_to(action_name)
      log.debug "in_order_to: #{action_name}"
      @current_binding = create_binding(action_name)
      yield self
      @current_binding = nil
    end

    def create_binding(action_name)
      InputBinding.new(action_name)
    end

    def hold(button, options={})
      log.debug "hold: #{button}, #{options}"
      @current_binding.add_input_listener(:hold, button, options)
    end

    def press(button, options={})
      log.debug "press: #{button}, #{options}"
      @current_binding.add_input_listener(:press, button, options)
    end

    def release(button, options={})
      log.debug "release: #{button}, #{options}"
      @current_binding.add_input_listener(:release, button, options)
    end

    def move(button, options={})
      log.debug "move: #{button}, #{options}"
      @current_binding.add_input_listener(:move, button, options)
    end
  end
end