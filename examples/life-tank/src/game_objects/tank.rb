class Tank < Gemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :ReceivesEvents
  has_behavior :Timeable
  has_behavior :Taggable

  attr_accessor :player

  FLIP_THRESHOLD = 0.50 * 1000.0
  FLIP_LIFT = -1000.0
  FLIP_SPIN = 4.5
  ANGLE_ADJUSTMENT_FACTOR = 1.5 / 20.0
  POWER_ADJUSTMENT_FACTOR = 1.0 / 20.0
  TOTAL_POWER = 100.0
  POWER_FACTOR = 60.0
  RELOAD_UPDATES_PER_SECOND = 1.0 / 30.0
  RELOAD_WARMPUP_IN_SECONDS = 5
  MOVEMENT_FACTOR = 25.0
#  RELOAD_WARMPUP_IN_SECONDS = 1.5
  INITIAL_LIFE = 100.0
  MAX_JUMP_POWER = 75_000.0
  JUMP_CHARGE_FACTOR = 50.0
  
  COLOR_WHEEL = [:green, :red, :yellow, :blue].map {|c| Color.new c}

  def load(player_index)
    @player_id = player_index
    
    set_image @game_state.manager(:render).get_cached_image(:tank_body)
    set_shape :Box, image.width, image.height / 2.0
    #set_physical_sprite_position_offset Vector.new(0.0, image.height / 2.0)
    set_friction 10.0
#    set_speed_limit 100.0
#    set_damping 0.06
    set_mass 25
    set_restitution 0.75
    on_after_body_position_changes :update_wheels
    @wheels = []
    @angle = 45.0
    @power = 50.0
    @life = INITIAL_LIFE

    @zero = Vector.new(0.0, 0.0)
    @barrel_offset = Vector.new 0.0, 10.0
    @barrel = @game_state.create :Turret
    attach_wheels
    attach_flag
    
    @barrel_anchor = Vector.new 0.0, -(@barrel.image.width / 2)

    @power_arrow_neck = @game_state.create :PowerArrowNeck
    @power_arrow_head = @game_state.create :PowerArrowHead

    @power_changed = true # to set the proper scale on the first update, flag as true
#    @movement = 0.0
    @twist = 0.0
    @jump_charge = 0.0

    on_update :update_tank

#    join_to_physical @barrel, :joint => :basic, :anchor => Vector.new(0.0, 0.0)

    handle_event :adjust_angle do |message|
      next unless message.player == @player_id
      new_angle = @angle + (message.value * ANGLE_ADJUSTMENT_FACTOR * message.delta)
      @angle = new_angle if new_angle < 90.0 && new_angle > -90.0
    end

    handle_event :adjust_power do |message|
      next unless message.player == @player_id
      new_power = @power + (message.value * POWER_ADJUSTMENT_FACTOR * message.delta)
      if new_power < TOTAL_POWER && new_power > 10.0
        @power_changed = true if new_power != @power # @power_changed is used during update
        @power = new_power
      end
    end

    handle_event :move,        :move_tank
    handle_event :fire,        :fire_shell
    handle_event :charge_jump, :charge_jump
    handle_event :jump,        :jump_tank

    on_countdown_complete do |name|
      if name == :shot
        @ready_to_fire = true
        @power_arrow_head.color = @power_arrow_neck.color = Color.new(:yellow)
      else
        raise "countdown #{name.inspect} not supported!"
      end
    end

    on_timer_tick do |timer|
      percent = timer.percent_complete
      @power_arrow_head.color = @power_arrow_neck.color = Color.new(percent, percent, percent)
    end

    on_physical_collided :take_damage

    reload_shot
  end

  def unload
    @game_state.remove @power_arrow_head
    @game_state.remove @power_arrow_neck
    @game_state.remove @barrel
    @game_state.remove @flag
    @wheels.each {|wheel| @game_state.remove wheel }
  end

  def take_damage(collision_event)
    return unless collision_event.other.has_tag? :damage
    @life -= collision_event.other.damage
    collision_event.other.remove_tag :damage # so other parts aren't damaged, should stop one-shots
    @game_state.remove self if @life < 1
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
    
    if @charging_jump
      @jump_charge += delta * JUMP_CHARGE_FACTOR unless @jump_charge >= MAX_JUMP_POWER
    end

    self.angular_velocity += @twist
    @twist = 0.0

    barrel_position = @barrel_anchor.pivot_around_degrees(@barrel_offset, physical_rotation + @angle)
    @barrel.position = barrel_position + body_position
    @barrel.image_rotation = @angle + physical_rotation - 90.0

    if @power_changed
      width_factor = 2 * @power / 100.0
      @power_arrow_neck.scale_image_from_original width_factor, 1.0
    end

    neck_offset = @barrel_anchor + Vector.new(0.0, -7.0 - (@power_arrow_neck.image.width + @barrel.image.width) / 2.0)
    neck_position = neck_offset.pivot_around_degrees(@zero, physical_rotation + @angle)
    @power_arrow_neck.position = neck_position + body_position
    @power_arrow_neck.image_rotation = @angle + physical_rotation - 90.0

    power_arrow_head_anchor = neck_offset + Vector.new(0.0, (7.0 - (@power_arrow_neck.image.width) / 2.0))
    head_position = power_arrow_head_anchor.pivot_around_degrees(@zero, physical_rotation + @angle)
    @power_arrow_head.position = head_position + body_position
    @power_arrow_head.image_rotation = @angle + physical_rotation - 90.0

#      @game_state.manager(:render).debug(:point, :red,   :position => (barrel_position + body_position))
#      @game_state.manager(:render).debug(:point, :green, :position => (neck_position + body_position))
#      @game_state.manager(:render).debug(:point, :blue,  :position => (head_position + body_position))

    life_percent = @life / INITIAL_LIFE
    self.color = @barrel.color = Color.new(1.0, life_percent, life_percent)
  end

  def update_wheels(event)
    return if @wheels.empty?
    @wheels[0].body_position = body_position + Vector.new(-16.0, 8.0)
    @wheels[1].body_position = body_position + Vector.new(  0.0, 8.0)
    @wheels[2].body_position = body_position + Vector.new( 16.0, 8.0)
  end

  def attach_wheels
    left_wheel = @game_state.create :TankWheel, self
    left_wheel.body_position = Vector.new(-16.0, 8.0)

    middle_wheel = @game_state.create :TankWheel, self
    middle_wheel.body_position = Vector.new(0.0, 8.0)

    right_wheel = @game_state.create :TankWheel, self
    right_wheel.body_position = Vector.new(16.0, 8.0)

    @wheels = [left_wheel, middle_wheel, right_wheel]
    left_wheel.add_excluded_physical middle_wheel
    left_wheel.add_excluded_physical right_wheel
    middle_wheel.add_excluded_physical right_wheel

    @wheels.each do |wheel|
      add_excluded_physical wheel
      wheel.on_physical_collided {|event| take_damage(event)}
      on_after_add_to_world do
#        join_to_physical wheel, :joint => :spring, :self_anchor => Vector.new(0.0), :other_anchor => wheel.body_position
        join_to_physical wheel, :joint => :basic, :anchor => wheel.body_position, :relaxation => -25.0
      end
    end
  end

  def charge_jump(message)
    return unless message.player == @player_id
#    return if message.value.nil?
    @charging_jump = true
  end

  def jump_tank(message)
    return unless message.player == @player_id
#    return if message.value.nil?
    @charging_jump = false
    # TODO: Check to see if tank is touching anything else
    jump_vector = Vector.from_polar_vector(@jump_charge, physical_rotation)
    add_force jump_vector
    @jump_charge = 0.0
  end

  def move_tank(message)
    return unless message.player == @player_id
    return if message.value.nil?
#    puts "moving tank: #{message.value}, #{message.delta}" if @player_id == 0
#    @movement = message.value
    @wheels.each {|wheel| wheel.turn(message.value * message.delta)}
  end

  def fire_shell(message)
    return unless message.player == @player_id
    return unless @ready_to_fire
    shell = @game_state.create :Shell
    shell_offset = @barrel_anchor + Vector.new(0.0, -5.0 - (@barrel.image.width / 2.0))
    shell_position = shell_offset.pivot_around_degrees(@zero, physical_rotation + @angle)
    shell.body_position = body_position + shell_position
    shell.physical_rotation = physical_rotation + @angle + 90.0
    shell_vector = Vector.from_polar_vector(@power * POWER_FACTOR, @angle + physical_rotation)
    shell.add_force shell_vector
    @game_state.manager(:sound).play_sound :fire_cannon
    add_force shell_vector.negate
    reload_shot
  end

  def reload_shot
    @ready_to_fire = false
    add_countdown :shot, RELOAD_WARMPUP_IN_SECONDS, RELOAD_UPDATES_PER_SECOND
  end
end
