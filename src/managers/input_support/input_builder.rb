require 'managers/input_support/input_binding'

module Jemini
  class InputBuilder
    def self.declare
      yield new
    end

    def in_order_to(action_name)
      @current_binding = create_binding(action_name)
      yield self
      @current_binding = nil
    end

    def create_binding(action_name)
      InputBinding.new(action_name)
    end

    def hold(button)
      @current_binding.add_input_listener(:hold, button)
    end

    def press(button)
      @current_binding.add_input_listener(:press, button)
    end

    def release(button)
      @current_binding.add_input_listener(:release, button)
    end

    def move(button)
      @current_binding.add_input_listener(:move, button)
    end
  end
end