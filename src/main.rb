require 'jruby'

include_class 'processing.core.PApplet'
include_class 'java.awt.Frame'
include_class 'java.awt.BorderLayout'

class DemoFrame < Frame
  def initialize
    super("Demo of embedded Processing PApplet")
    set_layout(BorderLayout.new)
    demo = Demo.new
    add(demo, BorderLayout::CENTER)
    demo.init
    pack
  end
end


class Scene < PApplet
  def setup
    
  end
  
  def draw
    
  end
end

class GameObject
  @@subclasses = Hash.new {|h,k| h[k] = []}
  def subclass(name)
    @@subclasses[name]
  end
  
  def self.has_behavior(behavior)
    # require target behavior
    # require dependant behaviors
    # mix in dependant behaviors
    # generate callback registration methods
  end
end

class View
  
end

class PacMan < GameObject
  has_behavior :Movable2D
  before_move {"foo bar baz"}
end

class Movable2D
  depends_on :Position2D
  has_callback :before_move
  has_callback :after_move
  
  def move(x, y)
    notify :before_move
    @x, @y = x, y
    notify :after_move
  end
  
  def x=(x)
    move(x, @y)
  end
  
  def y=(y)
    move(@x, y)
  end
end