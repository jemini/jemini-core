class Tank < Jemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :HandlesEvents
  has_behavior :Taggable
  has_behavior :ShootableBarrel
#  has_behavior :ChargedJumper
  has_behavior :ShellShooter
  
  attr_accessor :player_id, :life

  FLIP_THRESHOLD = 0.50 * 1000.0
  FLIP_LIFT = -10000.0
  FLIP_SPIN = 4.5
  MOVEMENT_FACTOR = 25.0
  INITIAL_LIFE = 100.0
  BALANCE_OFFSET = 400.0
  COLOR_WHEEL = [:green, :red, :yellow, :blue].map {|c| Color.new c}

  def load(player_index)
    @player_id = player_index
    
    set_image @game_state.manager(:render).get_cached_image(:tank_body)
    set_shape :Box, image.width, image.height / 2.0
    #set_physical_sprite_position_offset Vector.new(0.0, image.height / 2.0)
    set_friction 10.0
    set_mass 20
    set_restitution 1.0
    on_after_body_position_changes :update_wheels
#    on_after_body_position_changes :update_balance
    @wheels = []
    @life = INITIAL_LIFE

    attach_wheels
    attach_flag
#    attach_balance

    on_update :update_tank

    handle_event :move, :move_tank

    on_physical_collided :take_damage
  end

  def unload
    @game_state.remove @flag
    @wheels.each {|wheel| @game_state.remove wheel }
    @game_state.remove @balance
  end

  def take_damage(collision_event)
    return unless collision_event.other.has_tag? :damage
    collision_event.other.remove_tag :damage # so other parts aren't damaged, should stop one-shots
    self.life -= collision_event.other.damage
  end

  def explode
    explosion = @game_state.create :Explosion, :location => body_position, :radius => 40.0
    @game_state.remove self
  end
  
  def life=(value)
    @life = value
    explode if @life < 1
  end
  
private

  def attach_flag
    @flag = @game_state.create_on_layer :Flag, :flag, self
    @flag.color = COLOR_WHEEL[@player_id]
  end

  def update_tank(delta)
    if get_collision_events.any? {|collision_event| collision_event.other.has_tag? :ground }
      @flip_wait += delta
      if @flip_wait > FLIP_THRESHOLD
        @flip_wait = 0.0
        add_force(0.0, FLIP_LIFT)
        apply_angular_velocity(FLIP_SPIN) #TODO: Fix inconistent naming
      end
    else
      @flip_wait = 0.0
    end

    life_percent = @life / INITIAL_LIFE
    self.color = barrel.color = Color.new(1.0, life_percent, life_percent)
  end

  def update_wheels(event)
    return if @wheels.empty?
    @wheels[0].body_position = body_position + Vector.new(-16.0, 8.0)
    @wheels[1].body_position = body_position + Vector.new(  0.0, 8.0)
    @wheels[2].body_position = body_position + Vector.new( 16.0, 8.0)
#    @wheels[1].body_position = body_position + Vector.new( 16.0, 8.0)
  end

  def update_balance(event)
    return if @balance.nil?
    @balance.body_position = body_position + Vector.new(0.0, BALANCE_OFFSET)
  end

  def attach_balance
    @balance = @game_state.create :Balance
    @balance.body_position = Vector.new(0.0, BALANCE_OFFSET)
    on_after_add_to_world do
      join_to_physical @balance, :joint => :basic, :anchor => @balance.body_position, :relaxation => 0.0
      
#      join_to_physical @balance, :joint => :fixed_angle, :self_body_point => body_position, :other_body_point => @balance.body_position, :angle => -90.0
#      join_to_physical @balance, :joint => :fixed_angle, :angle => -90.0
#      join_to_physical @balance, :joint => :distance, :distance => 30.0
    end
  end

  def attach_wheels
    left_wheel = @game_state.create :TankWheel, self
    left_wheel.body_position = Vector.new(-16.0, 8.0)

    middle_wheel = @game_state.create :TankWheel, self
    middle_wheel.body_position = Vector.new(0.0, 8.0)

    right_wheel = @game_state.create :TankWheel, self
    right_wheel.body_position = Vector.new(16.0, 8.0)

    @wheels = [left_wheel, middle_wheel, right_wheel]
#    @wheels = [left_wheel, right_wheel]
    left_wheel.add_excluded_physical middle_wheel
    left_wheel.add_excluded_physical right_wheel
    middle_wheel.add_excluded_physical right_wheel

    @wheels.each do |wheel|
      add_excluded_physical wheel
      wheel.on_physical_collided {|event| take_damage(event)}
      on_after_add_to_world do
#        join_to_physical wheel, :joint => :spring, :self_anchor => Vector.new(0.0), :other_anchor => wheel.body_position
        join_to_physical wheel, :joint => :basic, :anchor => wheel.body_position, :relaxation => -25.0
#        join_to_physical wheel, :joint => :basic, :anchor => Vector::ORIGIN, :relaxation => 0.0
#        join_to_physical wheel, :joint => :distance, :distance => 7
      end
    end
  end

  def move_tank(message)
    return if message.value.nil?
    @wheels.each {|wheel| wheel.turn(message.value * message.delta)}
  end
end
