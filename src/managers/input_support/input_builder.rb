require 'managers/input_support/input_binding'

module Jemini
  class InputBuilder
    def self.declare
      yield new
    end

    def bind(*args)
      Gemini::BaseState.active_state.manager(:input).bindings << Jemini::InputBinding.new
    end
  end
end