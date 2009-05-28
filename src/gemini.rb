require 'color'
require 'vector'
require 'spline'
require 'inflector'

puts "gemini path: #{File.expand_path(File.dirname(__FILE__))}"
puts "gemini manager path: #{File.expand_path(File.dirname(__FILE__) + '/managers')}"
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/managers')
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/game_objects')
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/states')
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/input_helpers')

# Because Windows isn't friendly with JRuby
$LOAD_PATH << 'managers'
$LOAD_PATH << 'game_objects'
$LOAD_PATH << 'states'
$LOAD_PATH << 'input_helpers'

require 'math'
require 'proc_enhancement'
require 'game_object'
require 'message_queue'
require 'input_manager'
require 'base_state'
require 'inflector'
require 'basic_game_object_manager'
require 'basic_update_manager'
require 'basic_render_manager'

module Gemini
  class Main < Java::org::newdawn::slick::BasicGame
    include_class 'org.newdawn.slick.AppGameContainer'
    attr_accessor :screen_width, :screen_height, :initial_state
    
    def self.start_app(screen_title, screen_width, screen_height, initial_state, fullscreen=false)
      puts "in start app"
      main = Main.new(screen_title, initial_state)
      main.screen_width  = screen_width
      main.screen_height = screen_height
      container = AppGameContainer.new(main, screen_width, screen_height, fullscreen)
      container.vsync = false
      container.maximum_logic_update_interval = 60
      container.smooth_deltas = true
      #main.container = container
      container.start
    end
    
    def self.create_canvas(screen_title, screen_width, screen_height, initial_state)
      main = Main.new screen_title, initial_state
      main.screen_width  = screen_width
      main.screen_height = screen_height
      puts "creating canvas"
      $canvas = Java::org::newdawn::slick::CanvasGameContainer.new(main)
      puts "setting size to #{screen_width}, #{screen_height}"
      $canvas.set_size(screen_width, screen_height)
      puts "done setting size"
      container = $canvas.container
      container.vsync = true
      container.maximum_logic_update_interval = 60
      #container.start
      $canvas
    end
    
    def initialize(screen_title=nil, initial_state=:MainState)
      super(screen_title)
      @initial_state = initial_state
      @fresh_state = true
    end
    
    def init(container)
      @container = container
      BaseState.active_state = load_state(@initial_state)
      BaseState.active_state.load
    end
    
    def update(container, delta)
      #don't tell the new state that it now has to update load time worth of a delta
      if @fresh_state
        delta = 0
        @fresh_state = false
      end
      # Workaround for image loading with Slick.
      # Must be done in game init or game loop (instead of immediately in the event).
      if @queued_state
        @queued_state.load(*@state_args)
        BaseState.active_state = @queued_state
        @queued_state = nil
        @fresh_state = true
        return
      end
      BaseState.active_state.manager(:input).poll(@screen_width, @screen_height, delta)
      BaseState.active_state.manager(:message_queue).process_messages(delta)
      BaseState.active_state.manager(:update).update(delta)
      BaseState.active_state.manager(:game_object).__process_pending_game_objects
    end

    def render(container, graphics)
      BaseState.active_state.manager(:render).render(graphics)
    end
    
    def load_state(state_name, args = [])
      require "states/#{state_name.underscore}" unless Object.const_defined? state_name.camelize
      @state_args = args
      state_name.camelize.constantize.new @container, self
    end
    
    def queue_state(state)
      @queued_state = state
    end
  end
end