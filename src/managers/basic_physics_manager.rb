require 'behaviors/physical'
require 'events/physical_message'

#Controls objects that collide, fall with gravity, roll, etc.
class BasicPhysicsManager < Jemini::JameObject
  INTERPOLATION_THESHOLD  = 6.0
  MILLISECONDS_PER_UPDATE = 1000 / 60
  PHYS2D_UPDATE_DIFF      = (1000.to_f / 60.to_f) - MILLISECONDS_PER_UPDATE.to_f
  DELTA_FACTOR            = 0.01
  include_class 'net.phys2d.math.Vector2f'
  include_class 'net.phys2d.raw.World'
  include_class 'net.phys2d.raw.strategies.QuadSpaceStrategy'
  include_class 'net.phys2d.raw.strategies.BruteCollisionStrategy'
  has_behavior :ReceivesEvents
  
  def load
    @delta_debt = 0
    @world = World.new(Vector2f.new(0, 0), 5, QuadSpaceStrategy.new(20, 5))
#    @world = World.new(Vector2f.new(0, 0), 10, BruteCollisionStrategy.new)
    @world.add_listener self
    @game_state.manager(:update).on_update do |delta|
      update delta
    end
    
    @game_state.manager(:game_object).on_after_add_game_object do |game_object|
      add_to_world game_object if game_object.kind_of? Physical
    end
    
    @game_state.manager(:game_object).on_after_remove_game_object do |game_object|
      game_object.remove_from_world(@world) if game_object.kind_of? Physical
    end
    
    handle_event :toggle_debug_mode, :toggle_debug_mode
  end

  def update(delta)
    delta += @delta_debt
    @delta_debt = 0
    if delta == MILLISECONDS_PER_UPDATE
      sleep PHYS2D_UPDATE_DIFF / 1000.0
      step
    else
      temp_delta = delta
      until temp_delta <= 0
        new_delta = temp_delta > MILLISECONDS_PER_UPDATE ? MILLISECONDS_PER_UPDATE : temp_delta
        if new_delta < MILLISECONDS_PER_UPDATE
          @delta_debt = new_delta
          return #don't step, we'll try again next update
        else
          step
          temp_delta -= new_delta
        end
      end
    end
  end
  
  # there's a typo in the API, I swears it.
  def collision_occured(event)
    event.body_a.user_data.notify :physical_collided, PhysicsMessage.new(event, event.body_b.user_data)
    event.body_b.user_data.notify :physical_collided, PhysicsMessage.new(event, event.body_a.user_data)
  end
  
  #Turns drawing of physical bodies on/off.
  def toggle_debug_mode(message)
    @debug_mode = !@debug_mode
    @game_state.manager(:game_object).game_objects.each do |game_object|
      game_object.set_physical_debug_mode(@debug_mode) if game_object.kind_of? Physical
    end
  end
  
  #Takes a number representing the downward force to apply to physical objects.
  def gravity=(gravity_or_x)
    if gravity_or_x.kind_of? Numeric
      @world.set_gravity(0, gravity_or_x)
    else
      raise "Not implemented yet"
#      @world.set_gravity(gravity_or_x)
    end
  end

private
  def step
    @world.step # must step at fixed rate (1/60f) or results are unpredictable
  end

  def add_to_world(game_object)
    game_object.add_to_world(@world) 
    game_object.set_physical_debug_mode(true) if @debug_mode
  end
#  def colliding?(body)
#    0 < @world.get_contacts(body).size
#  end


end