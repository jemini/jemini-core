include_class 'org.newdawn.slick.BasicGame'
include_class 'org.newdawn.slick.AppGameContainer'

require 'message_queue'
require 'input_manager'
require 'base_state'
require 'game_object'
require 'inflector'

['behaviors', 'game_objects'].each do |dir|
  Dir.glob(File.expand_path(File.dirname(__FILE__) + "/#{dir}/**")).each do |file|
    require file if file =~ /\.\w+$/ #File.directory? is broken in current JRuby for dirs inside jars
  end
end

module Gemini
  class Main < BasicGame
    def initialize(screen_title, screen_width=640, screen_height=480, fullscreen=false)
      super(screen_title)
      @screen_width, @screen_height = screen_width, screen_height
      app = AppGameContainer.new(self, screen_width, screen_height, fullscreen)
      app.start
    end

    def init(container)
      MessageQueue.instance.start_processing
      InputManager.instance.setup(container, :MainGameKeymap)
      BaseState.active_state = load_state :MainState
    end
    
    def update(container, delta)
      InputManager.instance.poll(@screen_width, @screen_height)
      BaseState.active_state.update(delta)
    end

    def render(container, graphics)
      BaseState.active_state.render(graphics)
    end
    
  private
    def load_state(state_name)
      require "states/#{state_name.underscore}" unless Object.const_defined? state_name.camelize
      state_name.camelize.constantize.new
    end
  end
end