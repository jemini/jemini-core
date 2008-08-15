class Duke < Gemini::GameObject
  has_behavior :RecievesEvents
  has_behavior :Sprite
  has_behavior :UpdatesAtConsistantRate
  has_behavior :Taggable
  
  def load
    self.image = "duke.png"
    image_scaling 0.7
    4.times do
      @state.manager(:game_object).add_game_object Bullet.new
    end
    @last_fire_time = Time.now
    @moving_up = false
    @moving_down = false
    add_tag :duke
    
    handle_event :shoot, :shoot
    handle_event :move, :move
    
    on_tick do
      if @moving_up
        self.y -= 4
      end
      
      if @moving_down
        self.y += 4
      end
      
      @moving_up = false
      @moving_down = false
    end
  end
  
  def move(message)
    case message.value
    when :up
      @moving_up = true
    when :down
      @moving_down = true
    end
  end
  
  def shoot(message)
    if (Time.now - @last_fire_time) > 0.2
      @state.manager(:tag).find_by_tag(:bullet).each do |bullet|
        if bullet.x >= 640
          bullet.x = x + 80
          bullet.y = y + 10
          break
        end
      end
      @last_fire_time = Time.now
    end
  end
end

class Bullet < Gemini::GameObject
  has_behavior :Sprite
  has_behavior :CollidableWhenMoving
  has_behavior :UpdatesAtConsistantRate
  
  def load
    self.image = "jruby.png"
    image_scaling 0.3
    add_tag :bullet
    self.x = 700
  
    on_tick do
      if x < 640
        self.x += 10
      end
    end
  end
end

class DotNet < Gemini::GameObject
  RADIANS_PER_DEGREE = Math::PI/ 180
  
  has_behavior :Sprite
  has_behavior :CollidableWhenMoving
  has_behavior :UpdatesAtConsistantRate
  
  def load
    self.image = "DotNetLogo.jpg"
    image_scaling 0.1
    
    @timer = rand(300)
    @state = :waiting
    @y_median = 240
    collides_with_tags :duke, :bullet
    add_tag :dot_net
    
    on_tick do
      case @state
      when :waiting
        @timer += 1
        if @timer > 300
          @state = :attacking
          @timer = 0
          self.x = 640
          @y_median = rand(480 - height)
        end
      when :attacking
        if x < (0 - width)
          @state = :waiting
        end
        self.x -= 3
        self.y = @y_median + (50 * Math.sin(self.x * RADIANS_PER_DEGREE))
      end  
    end
    
    on_collided do |event, continue|
      puts "collided with #{event}"
      if event.collided_object.has_tag? :bullet
        @state = :dead
        self.x = 700
      end
    end
  end
end