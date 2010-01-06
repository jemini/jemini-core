require 'behaviors/spatial'
require 'events/physical_message'

#Makes an object interact with the physics engine.
class Physical < Jemini::Behavior

  INFINITE_MASS = Java::net::phys2d::raw::Body::INFINITE_MASS

  java_import "net.phys2d.raw.Body"
  java_import "net.phys2d.raw.shapes.Box"
  java_import "net.phys2d.raw.shapes.Circle"
  java_import "net.phys2d.raw.shapes.Line"
  java_import "net.phys2d.raw.shapes.Polygon"
  java_import "net.phys2d.raw.shapes.ConvexPolygon"
  java_import "net.phys2d.math.Vector2f"
  java_import 'net.phys2d.raw.AngleJoint'
  java_import 'net.phys2d.raw.BasicJoint'
  java_import 'net.phys2d.raw.SpringJoint'
  java_import 'net.phys2d.raw.FixedAngleJoint'
  java_import 'net.phys2d.raw.DistanceJoint'
  java_import 'net.phys2d.raw.FixedJoint'

  attr_reader :mass, :name, :shape
  depends_on :Spatial
  depends_on :Updates
  wrap_with_callbacks :mass=, :add_to_world, :body_position=, :set_body_position

  def load
    @mass = 1
    @shape = Box.new(1,1)
    setup_body
    @body.restitution = 0.0
    @body.user_data = @game_object
    @angular_damping = 0.0
    @game_object.enable_listeners_for :physical_collided
    @game_object.on_after_position_changes { move_body @game_object.position }
    @joints = []
    
    # Manual angular damping. New Phys2D may support this? If not, file a bug.
    @game_object.on_update do |delta|
      next if @angular_damping.zero? || angular_velocity.zero?
      decay = (delta * @angular_damping * angular_velocity) / (mass * shape.surface_factor)
      set_angular_velocity(angular_velocity - decay) unless decay.nan?
    end
  end

  def add_excluded_physical(physical_game_object)
    @body.add_excluded_body physical_game_object.instance_variable_get(:@__behaviors)[:Physical].instance_variable_get(:@body)
  end

  # prevent collision and interaction with all physicals now and in the future
  def exclude_all_physicals
    game_state.manager(:game_object).game_objects.select {|game_object| game_object.has_behavior? :Physical }.each {|physical| add_excluded_physical physical }
    
    game_state.manager(:game_object).on_before_add_game_object do |game_object, event|
      add_excluded_physical game_object if game_object.has_behavior? :Physical
    end
  end

  def physics_bitmask
    @body.bitmask
  end

  def physics_bitmask=(bitmask)
    @body.bitmask = bitmask
  end
  alias_method :set_physics_bitmask, :physics_bitmask=


  def body_position
    @body.position.to_vector
  end

  #Takes a Vector with the x/y coordinates to move the object to.
  def body_position=(vector)
    # set_position doesn't take a vector, only x/y
    @body.set_position(vector.x, vector.y)
  end
  alias_method :set_body_position, :body_position=

  def add_joint(joint)
    @joints << joint
  end
  # See about Phys2D joints here: http://www.cokeandcode.com/phys2d/source/javadoc/net/phys2d/raw/Joint.html
  # TODO: Make the joint a game object and/or behavior
  def join_to_physical(physical_game_object, options={})
    other_body = physical_game_object.instance_variable_get(:@__behaviors)[:Physical].instance_variable_get(:@body)

    self_body_point  = (options[:self_body_point]  || Vector::ORIGIN).to_phys2d_vector
    other_body_point = (options[:other_body_point] || Vector::ORIGIN).to_phys2d_vector
    joint = case options[:joint]
            when :distance
              DistanceJoint.new(@body, other_body, self_body_point, other_body_point, options[:distance])
            when :fixed_angle
              FixedAngleJoint.new(@body, other_body, self_body_point, other_body_point, options[:angle])
            when :angle
              AngleJoint.new(@body, other_body, self_body_point, other_body_point, options[:self_body_angle], options[:other_body_angle])
            when :basic
              joint = BasicJoint.new(@body, other_body, options[:anchor].to_phys2d_vector)
              joint
            when :fixed
              joint = FixedJoint.new(@body, other_body)
              joint
            when :spring
              joint = SpringJoint.new(@body, other_body, options[:self_anchor].to_phys2d_vector, options[:other_anchor].to_phys2d_vector)
              joint
            else
              raise "Joint type #{options[:joint].inspect} not supported."
            end
    joint.relaxation = options[:relaxation] if options[:relaxation]

    @joints << joint 

    @world.add joint
    joint
  end

  #The maximum speed the object is allowed to travel.  Takes either a Vector with the x/y limits or the numeric value to assign to both x and y.
  def speed_limit=(vector_or_shared_value)
    if vector_or_shared_value.kind_of? Numeric
      axis_limit_x = axis_limit_y = vector_or_shared_value / Jemini::Math::SQUARE_ROOT_OF_TWO
    else
      axis_limit_x = vector_or_shared_value.x
      axis_limit_y = vector_or_shared_value.y
    end
    @body.set_max_velocity(axis_limit_x, axis_limit_y)
  end
  alias_method :set_speed_limit, :speed_limit=

  def width
    @body.shape.bounds.width
  end

  def height
    @body.shape.bounds.height
  end

  def radius
    @body.shape.radius
  end

  def box_size
    @body.shape.size
  end

  #Set the absolute rotation.
  def physical_rotation=(degrees)
    @body.rotation = Jemini::Math.degrees_to_radians(degrees)
  end
  alias_method :set_physical_rotation, :physical_rotation=

  #Set the rotation relative to the current rotation.
  def rotate_physical(degrees)
    @body.adjust_rotation Jemini::Math.degrees_to_radians(degrees)
  end

  def physical_rotation
    Jemini::Math.radians_to_degrees(@body.rotation)
  end

  def physical_rotatable?
    @body.rotatable?
  end

  #Set whether the object is allowed to rotate.
  def physical_rotatable=(rotatable)
    @body.rotatable = rotatable
  end
  alias_method :set_physical_rotatable, :physical_rotatable=

  #Push on the object.
  #Takes either a Vector or x/y values representing the force to apply.
  def add_force(x_or_vector, y = nil)
    if y.nil?
      @body.add_force(x_or_vector.to_phys2d_vector)
    else
      @body.add_force(Vector2f.new(x_or_vector, y))
    end
  end

  #Set the force being applied to the object.  Disregards all other forces.
  def set_force(x, y)
    @body.set_force(x, y)
  end

  def force
    @body.force
  end

  #Adjust the object's velocity.
  #Takes either a Vector or x/y values representing the adjustment to make.
  def add_velocity(x_or_vector, y = nil)
    if x_or_vector.kind_of? Vector
      @body.adjust_velocity(x_or_vector.to_phys2d_vector)
    else
      @body.adjust_velocity(Java::net::phys2d::math::Vector2f.new(x_or_vector, y))
    end
  end

  def velocity
    @body.velocity.to_vector
  end

  def velocity=(vector)
    @body.adjust_velocity(Java::net::phys2d::math::Vector2f.new(vector.x - @body.velocity.x, vector.y - @body.velocity.y))
  end
  alias_method :set_velocity, :velocity=

  def angular_velocity
    @body.angular_velocity
  end

  def angular_velocity=(delta)
    velocity = (delta - angular_velocity).to_f
    @body.adjust_angular_velocity velocity 
  end
  alias_method :set_angular_velocity, :angular_velocity=

  def apply_angular_velocity(velocity)
    @body.adjust_angular_velocity velocity
  end

  #Immediately halt movement.
  def come_to_rest
    current_velocity = @body.velocity
    add_velocity(-current_velocity.x, -current_velocity.y)
    set_angular_velocity(0)
    @body.is_resting = true
  end

  #Takes the following values:
  #[:infinite] Object has infinite mass.
  #[number] Value to set the mass to.
  def mass=(mass)
    @mass = mass
    @mass = @mass.kind_of?(Symbol) ? INFINITE_MASS : @mass
    @body.set(@shape, @mass)
    # TODO: Consider moving to set_shape
    # A body's position is lost when it moves, reset the position to where it was
    @body.move @game_object.position.x, @game_object.position.y
  end
  alias_method :set_mass, :mass=

  def restitution
    @body.restitution
  end

  def restitution=(restitution)
    @body.restitution = restitution
  end
  alias_method :set_restitution, :restitution=

  #Set the shape of the object as seen by the physics engine.
  #call-seq:
  #set_shape(:Box, width, height)
  #set_shape(:Circle, radius)
  #set_shape(:Polygon, *vectors)
  #
  def set_shape(shape, *params)
    # Save off data that is destroyed when @body.set is called
    saved_damping = damping
    saved_angular_damping = angular_damping
    saved_body_position = body_position
    saved_friction = friction
    saved_position = @game_object.position
    saved_x, saved_y = @game_object.x, @game_object.y
    if shape.respond_to?(:to_str) || shape.kind_of?(Symbol)
      case shape.to_s
      when 'Polygon', 'ConvexPolygon'
        params = [params.map {|vector| vector.to_phys2d_vector }.to_java(Vector2f)]
      when 'Line'
        params = params.map {|vector| vector.to_phys2d_vector }.to_java(Vector2f)
      end
      @shape = ("Physical::" + shape.to_s).constantize.new(*params)
    else
      @shape = shape
    end

    @body.set(@shape, @mass)
    set_body_position saved_body_position
    @game_object.set_position saved_position
    set_friction saved_friction
    @game_object.position = Vector.new(saved_x, saved_y)
    self.damping = saved_damping
    self.angular_damping = saved_angular_damping
  end

  def name=(name)
    @name = name
    setup_body
  end

  #Place this object under the control of the physics engine.
  def add_to_world(world)
    world.add @body
    @world = world
  end

  #Remove this object from the control of the physics engine.
  def remove_from_world(world)
    world.remove @body
    @joints.each {|j| world.remove j }
    @world = nil
  end

  #Turn debug mode on or off for this object.
  def physical_debug_mode=(flag)
    if flag
      @game_object.add_behavior :DebugPhysical
    else
      @game_object.remove_behavior :DebugPhysical
    end
  end
  alias_method :set_physical_debug_mode, :physical_debug_mode=

  def movable=(flag)
    @body.moveable = flag
  end
  alias_method :set_movable, :movable=

  def movable?
    @body.moveable?
  end

  #The amount of air friction slowing the object's movement.
  def damping
    @body.damping
  end

  def damping=(damping)
    @body.damping = damping
  end
  alias_method :set_damping, :damping=

  def angular_damping
    @angular_damping
    #@body.rot_damping
  end

  def angular_damping=(damping)
    @angular_damping = damping
    #@body.rot_damping = damping
  end
  alias_method :set_angular_damping, :angular_damping=

  #Set this object as immobile.
  def set_static_body
    come_to_rest
    @body.moveable = false
    @body.rotatable = false
  end

  #Set whether gravity affects this object.
  def gravity_effected=(flag)
    @body.gravity_effected = flag
  end
  alias_method :set_gravity_effected, :gravity_effected=

  #The amount of friction slowing the object's movement.
  def friction
    @body.friction
  end

  def friction=(friction)
    @body.friction = friction
  end
  alias_method :set_friction, :friction=

#  def get_colliding_game_objects(tangible_game_object)
#    # TODO: Tangibles only?
#    tangible_game_object
#  end

  #Get a list of CollisionEvents for objects currently colliding with this one.
  def get_collision_events
    return [] if @world.nil? # a worthwhile check in some cases. Maybe because the physical is removed but the game object is not?
    @world.get_contacts(@body).map do |event|
      body_method = event.body_a == @body ? :body_b : :body_a
      PhysicsMessage.new(event, event.send(body_method).user_data)
    end
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

  def move_body(vector)
    @body.move(vector.x, vector.y)
  end
end