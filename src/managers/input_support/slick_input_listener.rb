module Jemini
  class SlickInputListener
    java_import 'org.newdawn.slick.InputListener'
    include InputListener

    def initialize(state)
      @state = state
    end

    def isAcceptingInput
      #@state == BaseState.active_state
      true
    end

    def method_missing(method, *args)
      return if (method == :inputEnded) || @state != BaseState.active_state
      @state.manager(:message_queue).post_message SlickInputMessage.new(method, args)
    end
  end
end