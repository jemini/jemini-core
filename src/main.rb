require 'jruby'
require 'behavior'
require 'game_object'
require 'input_manager'

include_class 'org.newdawn.slick.BasicGame'
include_class 'org.newdawn.slick.AppGameContainer'
include_class 'org.newdawn.slick.Input'

class Movable2D < Behavior
  depends_on :Position2D
  declared_methods :move
  #has_callback :before_move
  #has_callback :after_move
  
  def move(x, y)
    self.x = x
    self.y = y
  end
end

class Position2D < Behavior
  declared_methods :x, :y, :x=, :y=
  attr_accessor :x, :y
  
  def load
    @x = 0
    @y = 0
  end
end

class UpdatesAtConsistantRate < Behavior
  declared_methods :update, :updates_per_second, :updates_per_second=
  attr_accessor :updates_per_second
  
  def load
    @updates_per_second = 0
    @update_delay = 0
    @time_since_last_update = 0
  end
  
  def updates_per_second=(count)
    if 0 == count
      @update_delay = 0
    else
      @update_delay = 1000 / count
    end
  end
  
  def update(delta_in_milliseconds)
    @time_since_last_update += delta_in_milliseconds
    if @time_since_last_update > @update_delay
      @time_since_last_update -= @update_delay
      tick
    end
  end
end

class RecievesKeyboardEvents < Behavior
  include_class 'org.newdawn.slick.InputListener'
  include InputListener
  
  declared_methods :register_key_events
  
  def load
    InputManager.input.addListener(self)
    @mappings = {:pressed => [], :released => []}
    
    #    %w{ controllerButtonPressed controllerButtonReleased controllerDownPressed 
    #    controllerDownReleased controllerLeftPressed controllerLeftReleased 
    #    controllerRightPressed controllerRightReleased controllerUpPressed 
    #    controllerUpReleased inputEnded isAcceptingInput keyPressed keyReleased 
    #    mouseClicked mouseMoved mousePressed mouseWheelMoved setAcceptingInput setInput }.each do |method|
    #      puts "creating method def #{method}(*args); end"
    #      instance_eval("def #{method}(*args); end", __FILE__, __LINE__)
    #    end
  end
  
  def register_key_events(key_map)
    key_map.each do |key, method|
      
    end

  end
  
  #  def keyPressed(key_code, char)
  #    puts "pressed"
  #  end
  #  
  #  def keyReleased(key_code, char)
  #    puts "released"
  #  end
  
  def isAcceptingInput
    true
  end
  
  def method_missing(method, *args, &block)
    puts "method called: #{method} with args: #{args}"
  end
end


class PacMan < GameObject
  has_behavior :Movable2D
  has_behavior :Sprite
  has_behavior :UpdatesAtConsistantRate
  has_behavior :RecievesKeyboardEvents
  
  def load
    @actions = [:right]
    register_key_events :right_arrow_pressed => :move_right, :left_arrow_pressed => :move_left, :right_arrow_released => :stop_moving_right, :left_arrow_released => :stop_moving_left
  end
  
  def tick
    @actions.each do |action|
      case action
      when :left
        self.x -= 1
      when :right
        self.x += 1
      end
    end
  end
  
  #  def move_right
  #    @actions << :right
  #  end
  #  
  #  def move_left
  #    @actions << :left
  #  end
  #  
  #  def stop_moving_right
  #    @actions.delete :right
  #  end
  #  
  #  def stop_moving_left
  #    @actions.delete :left
  #  end
end

class Sprite < Behavior
  include_class 'org.newdawn.slick.Image'
  declared_methods :draw, :image, :image=
  attr_accessor :image

  def image=(sprite_name)
    if sprite_name.kind_of? Image
      @image = sprite_name
    else
      @image = Image.new(sprite_name)
    end
  end
  
  def draw
    @image.draw(x, y)
  end
end

class MainGame < BasicGame
  def initialize
    super("Gemini game engine")
  end
  
  def init(container)
    @pacman = PacMan.new
    @pacman.image = "data/duke.png"
    @pacman.updates_per_second = 30
  end
  
  def update(container, delta)
    InputManager.poll(512,512)
    @pacman.update(delta)
  end
  
  def render(container, g)
    @pacman.draw
  end
end

app = AppGameContainer.new(MainGame.new, 512, 512, false)
InputManager.initialize(512)
app.start()
