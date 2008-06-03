include_class 'org.newdawn.slick.BasicGame'
include_class 'org.newdawn.slick.state.GameState'
include_class 'org.newdawn.slick.AppGameContainer'

require 'message_queue'
require 'input_manager'

module Gemini
  class Main < BasicGame
    def initialize(screen_title, screen_width, screen_height, fullscreen=false)
      super(screen_title)
      @screen_width, @screen_height = screen_width, screen_height
      app = AppGameContainer.new(self, screen_width, screen_height, fullscreen)
      app.start
    end

    def init(container)
      MessageQueue.instance.start_processing
      InputManager.instance.setup(container)
    end
    
    def update(container, delta)
      InputManager.instance.poll(@screen_width, @screen_height)
    end

    def render(container, graphics)

    end
  end
end