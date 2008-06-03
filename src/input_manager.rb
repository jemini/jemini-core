include_class 'org.newdawn.slick.Input'
include_class 'org.newdawn.slick.InputListener'
require 'message_queue'
require 'singleton'

module Gemini
  class GeminiInputListener
    include InputListener

    def isAcceptingInput
      true
    end

    def method_missing(method, *args)
      return if method == :inputEnded
      MessageQueue.instance.post_message(:slick_input, [method, args])
    end
  end

  # Consumes raw slick_input events and output events based on 
  # registered key bindings.
  class InputManager
    include Singleton
    
    def setup(container)
      @raw_input = container.input
      @raw_input.add_listener Gemini::GeminiInputListener.new
      MessageQueue.instance.add_listener(:slick_input, self) do |type, message|
        puts "#{message[0]}: #{message[1]}"
      end
    end
        
    def poll(screen_width, screen_height)
      @raw_input.poll(screen_width, screen_height)
    end
  end
end