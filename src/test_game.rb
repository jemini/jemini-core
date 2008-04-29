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

class Demo < PApplet
  LOGIC_TICKS_PER_SECOND = 60
  LOGIC_TICK_TIME = 1000/LOGIC_TICKS_PER_SECOND
  
  def setup
    size(600,200)
    background(100,200,100)
    @player = Player.new(self, "data/duke.png", 0, 0)
    @enemy = Enemy.new(self, "data/DotNetLogo.jpg", 400,rand(200), 100,60)
    @sprites = [@enemy, @player]
    @last_frame_time = millis
  end
  
  def update
    delta = (millis - @last_frame_time) / LOGIC_TICK_TIME
    if delta > 1.0
      @sprites.each{|sprite| sprite.update(delta)}
      @player.shots.each do |shot| 
        if @enemy.collided_with? shot
          @enemy.hit
          shot.x += 600
        end
      end
    end
  end
  
  def draw
    background(100,200,100)
    update
    @sprites.each {|sprite| sprite.draw}
  end
end

class Entity
  attr_accessor :x, :y, :width, :height
  
  def initialize(parent, source, x, y, width = nil, height = nil)
    @parent = parent
    if source.kind_of? String
      @sprite = parent.load_image(source)
    else
      @sprite = source
    end
    @x, @y = x, y
    @width = width || @sprite.width
    @height = height || @sprite.height
    
  end
  
  def draw
    @parent.image(@sprite, @x, @y, @width, @height)
  end
  
  def collided_with?(other)
    if ((other.x <= @x + @width) && ((other.x + other.width) >= @x)) &&
       ((other.y <= @y + @height) && ((other.y + other.height) >= @y))
      true
    else
      false
    end
  end
  
  def update(delta); end
end

class Player < Entity
  attr_reader :shots
  MOVE_RATE = 3
  
  def initialize(*args)
    super
    @shots = []
    @last_shot_fired = @parent.millis
  end
  
  def update(delta)
    case @parent.key
    when " "[0]
      fire
    when "w"[0]
      move :up
    when "a"[0]
      move :left
    when "s"[0]
      move :down
    when "d"[0]
      move :right
    end
    @parent.key = 0
    
    @shots.each{|shot| shot.update(delta)}
  end
  
  def fire
    if((@parent.millis - @last_shot_fired) > 500)
      @shots << Shot.new(@parent, nil, @x + 110, @y + 22, 25, 25)
      @last_shot_fired = @parent.millis
    end
  end
  
  def move(direction)
    case direction
    when :up
      @y -= MOVE_RATE
    when :left
      @x -= MOVE_RATE
    when :right
      @x += MOVE_RATE
    when :down
      @y += MOVE_RATE
    end
  end
  
  def draw
    super
    @shots.delete_if{|shot| shot.dead?}.each{|shot| shot.draw}
  end
end

class Enemy < Entity
  MOVE_SPEED = 2
  
  def initialize(*args)
    super
    @scale = 1
    @original_width = @width
    @original_height = @height
    @direction = :up
  end
  
  def draw
    @width = (@original_width * @scale.to_f).to_i
    @height = (@original_height * @scale.to_f).to_i
    super
  end
  
  def hit
    @scale -= 0.2
    if @scale <= 0
      puts "You win!"
    end
  end
  
  def update(delta)
    @scale += 0.001
    if :up == @direction
      @y -= MOVE_SPEED
    else
      @y += MOVE_SPEED
    end
    @direction = :down if @y < 0
    @direction = :up if @y > (200 - @height)
  end
end

class Shot < Entity
  MOVEMENT_SPEED = 8
  
  def initialize(parent, source, x, y, width = nil, height = nil)
    @@shot_image = parent.load_image("data/jruby.png") unless self.class.class_variables.member?("@@shot_image")
    super(parent, @@shot_image, x, y, width, height)
  end
  
  def update(delta)
    @x += MOVEMENT_SPEED
  end
  
  def dead?
    @x > 620
  end
end

demo = DemoFrame.new
demo.show