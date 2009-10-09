class ShootableBarrel < Jemini::Behavior
  RELOAD_WARMPUP_IN_SECONDS = 3.5
  RELOAD_UPDATES_PER_SECOND = 1.0 / 30.0
  ANGLE_ADJUSTMENT_FACTOR = 1.5 / 20.0
  POWER_ADJUSTMENT_FACTOR = 1.0 / 20.0
  TOTAL_POWER = 100.0
  
  depends_on :Updates
  depends_on :HandlesEvents
  depends_on :Physical
  depends_on :Timeable
  
  attr_accessor :power, :angle, :barrel, :ready_to_fire
  
  def load
    @angle = 45.0
    @power = 50.0

    @zero = Vector.new(0.0, 0.0)
    @barrel_offset = Vector.new 0.0, 10.0
    @barrel = @game_object.game_state.create :Turret

    @power_arrow_neck = @game_object.game_state.create :PowerArrowNeck
    @power_arrow_head = @game_object.game_state.create :PowerArrowHead
    @power_changed = true # to set the proper scale on the first update, flag as true

    @game_object.handle_event :adjust_angle, :handle_angle_adjustment
    @game_object.handle_event :adjust_power, :handle_power_adjustment
    @game_object.handle_event :fire_weapon, :dispatch_fire_weapon
    
    @game_object.on_update :update_barrel_and_arrow

    @game_object.on_countdown_complete do |name|
      if name == :shot
        self.ready_to_fire = true
      else
        raise "countdown #{name.inspect} not supported!"
      end
    end

    @game_object.on_timer_tick do |timer|
      percent = timer.percent_complete
      @power_arrow_head.color = @power_arrow_neck.color = Color.new(percent, percent, percent)
    end
    
    charge_weapon

  end

  def unload
    @game_object.game_state.remove @power_arrow_head
    @game_object.game_state.remove @power_arrow_neck
    @game_object.game_state.remove @barrel
  end

  def barrel_anchor
    @barrel_anchor ||= Vector.new(0.0, -(@barrel.image.width / 2))
  end

  def barrel_width
    @barrel.image.width
  end

  def update_barrel_and_arrow(delta)
    barrel_position = barrel_anchor.pivot_around_degrees(@barrel_offset, @game_object.physical_rotation + @angle)
    @barrel.position = barrel_position + @game_object.body_position
    @barrel.image_rotation = @angle + @game_object.physical_rotation - 90.0

    if @power_changed
      width_factor = 2 * @power / 100.0
      @power_arrow_neck.scale_image_from_original width_factor, 1.0
    end

    neck_offset = barrel_anchor + Vector.new(0.0, -7.0 - (@power_arrow_neck.image.width + @barrel.image.width) / 2.0)
    neck_position = neck_offset.pivot_around_degrees(@zero, @game_object.physical_rotation + angle)
    @power_arrow_neck.position = neck_position + @game_object.body_position
    @power_arrow_neck.image_rotation = angle + @game_object.physical_rotation - 90.0

    power_arrow_head_anchor = neck_offset + Vector.new(0.0, (7.0 - (@power_arrow_neck.image.width) / 2.0))
    head_position = power_arrow_head_anchor.pivot_around_degrees(@zero, @game_object.physical_rotation + angle)
    @power_arrow_head.position = head_position + @game_object.body_position
    @power_arrow_head.image_rotation = angle + @game_object.physical_rotation - 90.0

#      @game_object.game_state.manager(:render).debug(:point, :red,   :position => (barrel_position + body_position))
#      @game_object.game_state.manager(:render).debug(:point, :green, :position => (neck_position + body_position))
#      @game_object.game_state.manager(:render).debug(:point, :blue,  :position => (head_position + body_position))
  end

  def charge_weapon
    self.ready_to_fire = false
    @game_object.add_countdown :shot, RELOAD_WARMPUP_IN_SECONDS, RELOAD_UPDATES_PER_SECOND
  end

  def ready_to_fire?
    @ready_to_fire
  end

  def ready_to_fire=(value)
    @ready_to_fire = value
    color = (value ? Color.new(:yellow) : Color.new(:black))
    @power_arrow_head.color = @power_arrow_neck.color = color
  end

  # TODO: Consider auto-wiring messages based on dispatch_ or handle_ method names
  def dispatch_fire_weapon(message)
    return unless ready_to_fire?
    @game_object.fire_weapon(@power, @angle)
    charge_weapon
  end

  def handle_angle_adjustment(message)
    new_angle = angle + (message.value * ANGLE_ADJUSTMENT_FACTOR * message.delta)
    self.angle = new_angle if new_angle < 90.0 && new_angle > -90.0
  end

  def handle_power_adjustment(message)
    new_power = power + (message.value * POWER_ADJUSTMENT_FACTOR * message.delta)
    if new_power < TOTAL_POWER && new_power > 10.0
      @power_changed = true if new_power != @power # @power_changed is used during update
      self.power = new_power
    end
  end

end