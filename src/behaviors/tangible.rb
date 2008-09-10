class Tangible < Spatial
  DEGREES_TO_RADIANS_MULTIPLIER = Math::PI / 180
  RADIANS_TO_DEGREES_MULTIPLIER = 180 / Math::PI
  
  include_class "net.phys2d.raw.Body"
  include_class "net.phys2d.raw.shapes.Box"
  include_class "net.phys2d.raw.shapes.Circle"
  include_class "net.phys2d.raw.shapes.Line"
  include_class "net.phys2d.raw.shapes.Polygon"
  include_class "net.phys2d.raw.shapes.ConvexPolygon"
  include_class "net.phys2d.math.Vector2f"
  
  INFINITE_MASS = Body::INFINITE_MASS
  attr_reader :mass, :name, :shape
  wrap_with_callbacks :move
  declared_methods :x, :y, :height, :width, :move, :mass, :mass=, :set_mass, :shape,
                   :set_shape, :name, :name=, :rotation, :rotation=, :set_rotation, :add_force, :force,
                   :set_force, :come_to_rest, :add_to_world, :remove_from_world, :set_tangible_debug_mode,
                   :tangible_debug_mode=, :restitution, :restitution=, :set_restitution, :add_velocity,
                   :set_static_body, :rotatable=, :set_rotatable, :rotatable?, :velocity, :wish_move,
                   :set_movable, :movable=, :movable?, :set_position, #:set_safe_move, :safe_move=,
                   :damping, :set_damping, :damping=
  
  def load
    @mass = 1
    @shape = Box.new(1,1)
    setup_body
    @body.restitution = 0.0
    @body.user_data = @target
    @target.enable_listeners_for :collided
  end
  
  def x
    @body.position.x
  end
  
  def y
    @body.position.y
  end
  
  def set_position(x, y)
    @body.set_position(x, y)
  end
  
#  def safe_move=(safe_move)
#    @safe_move = safe_move
#    if safe_move
#      puts "adding safe move listener"
#      listen_for(:collided, @target) do
#        puts "collision event"
#        if @safe_move
#          puts "position: #{@body.position}"
#          puts "last position: #{@body.last_position}"
#          #@body.set_position(@body.last_position.x, @body.last_position.y)
#          puts "reseting position to #{@last_x}, #{@last_y}"
#          @body.set_position(@last_x, @last_y)
#        end
#      end
#    end
#  end
#  alias_method :set_safe_move, :safe_move=
  
  def wish_move(x, y)
    # WARNING: @body.last_position is not to be trusted. We'll just handle it ourselves.
    @last_x = @target.x
    @last_y = @target.y
    @body.move(x, y)
    #@body.set_position(@last_x, @last_y) if @target.game_state.manager(:physics).colliding? @body
  end
  
  def move(x, y)
    @body.move(x, y)
  end
  
  def width
    @body.shape.bounds.width
  end
  
  def height
    @body.shape.bounds.height
  end
  
  def rotation=(rotation)
    @body.rotation = rotation * DEGREES_TO_RADIANS_MULTIPLIER
  end
  alias_method :set_rotation, :rotation=
  
  def rotation
    @body.rotation * RADIANS_TO_DEGREES_MULTIPLIER
  end
  
  def rotatable?
    @body.rotatable?
  end
  
  def rotatable=(rotatable)
    @body.rotatable = rotatable
  end
  alias_method :set_rotatable, :rotatable=
  
  def add_force(x, y = nil)
    if y.nil?
      @body.add_force(x)
    else
      @body.add_force(Vector2f.new(x, y))
    end
  end
  
  def set_force(x, y)
    @body.set_force(x, y)
  end
  
  def force
    @body.force
  end
  
  def add_velocity(x, y)
    @body.adjust_velocity(Java::net::phys2d::math::Vector2f.new(x, y))
  end
  
  def velocity
    @body.velocity
  end
  
  def come_to_rest
    current_velocity = @body.velocity
    add_velocity(-current_velocity.x, -current_velocity.y)
    @body.is_resting = true
  end
  
  def mass=(mass)
    @mass = mass
    @body.set(@shape, @mass)
  end
  alias_method :set_mass, :mass=
  
  def restitution
    @body.restitution
  end
  
  def restitution=(restitution)
    @body.restitution = restitution
  end
  alias_method :set_restitution, :restitution=
  
  def set_shape(shape, *params)
    if shape.respond_to?(:to_str) || shape.kind_of?(Symbol)
      @shape = ("Tangible::" + shape.to_s).constantize.new(*params)
    else
      @shape = shape
    end
    @body.set(@shape, @mass)
  end
  
  def name=(name)
    @name = name
    setup_body
  end
  
  def add_to_world(world)
    world.add @body
  end
  
  def remove_from_world(world)
    world.remove @body
  end
  
  def tangible_debug_mode=(mode)
    if mode
      add_behavior :DebugTangible 
    else
      remove_behavior :DebugTangible
    end
  end
  alias_method :set_tangible_debug_mode, :tangible_debug_mode=
  
  def movable=(movable)
    @body.moveable = movable
  end
  alias_method :set_movable, :movable=
  
  def movable?
    @body.moveable?
  end
  
  def damping
    @body.damping
  end
  
  def damping=(damping)
    @body.damping = damping
  end
  alias_method :set_damping, :damping=
  
  def set_static_body
    @body.moveable = false
    @body.rotatable = false
    #@body.is_resting = true
  end
  
private
  def setup_body
    if @name
      @body = Body.new(@name, @shape, @mass)
    else
      @body = Body.new(@shape, @mass)
    end
    
    x = @body.position.x
    y = @body.position.y

    @body.set(@shape, @mass)
    @body.move(x, y)
  end
end