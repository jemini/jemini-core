include_class 'org.newdawn.slick.BasicGame'
include_class 'org.newdawn.slick.AppGameContainer'
include_class 'org.newdawn.slick.Input'
include_class 'org.newdawn.slick.InputListener'

require 'message_queue'

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

class Gemini < BasicGame
  def initialize(screen_title, screen_width, screen_height, fullscreen=false)
    super(screen_title)
    @screen_width, @screen_height = screen_width, screen_height
    app = AppGameContainer.new(self, screen_width, screen_height, fullscreen)
    app.start
  end
  
  def init(container)
    @raw_input = container.input
    @raw_input.add_listener GeminiInputListener.new
    
    # Replace with an input manager class that consumes raw slick_input events
    # and output relevant events based on some configurable input mapping
    # something like KEY_A => :left, KEY_W => :up, etc.
    MessageQueue.instance.add_listener(:slick_input, self) do |type, message|
      puts "#{message[0]}: #{message[1]}"
    end
    MessageQueue.instance.start_processing
  end
  
  def update(container, delta)
    @raw_input.poll(@screen_width, @screen_height)
  end
  
  def render(container, graphics)
    
  end
end