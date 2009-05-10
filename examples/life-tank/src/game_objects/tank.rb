class Tank < Gemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :RecievesEvents
  has_behavior :Timeable
  has_behavior :Taggable

  attr_accessor :player
  
  ANGLE_ADJUSTMENT_FACTOR = 1.5
  POWER_ADJUSTMENT_FACTOR = 1.0
  TOTAL_POWER = 100.0
  POWER_FACTOR = 6.0
  RELOAD_UPDATES_PER_SECOND = 1.0 / 30.0
  RELOAD_WARMPUP_IN_SECONDS = 5
  INITIAL_LIFE = 100.0
  
  def load(player_index)
    @player_id = player_index
    set_bounded_image @game_state.manager(:render).get_cached_image(:tank_body)
    set_friction 1.0
    @angle = 45.0
    @power = 50.0
    @life = INITIAL_LIFE
    
    @zero = Vector.new(0.0, 0.0)

    @barrel = @game_state.create :Turret
    @barrel_anchor = Vector.new 0.0, -((image.height.to_f * 3.0 / 4.0))

    @power_arrow_neck = @game_state.create :PowerArrowNeck
    @power_arrow_head = @game_state.create :PowerArrowHead

    @power_changed = true # to set the proper scale on the first update, flag as true
    
    on_update do
      barrel_position = @barrel_anchor.pivot_around_degrees(@zero, physical_rotation + @angle)
      @barrel.position = barrel_position + body_position
      @barrel.image_rotation = @angle + physical_rotation - 90.0

      if @power_changed
        width_factor = 2 * @power / 100.0
        @power_arrow_neck.scale_image_from_original width_factor, 1.0
      end
      
      shell_offset = @barrel_anchor + Vector.new(0.0, -(@power_arrow_neck.image.width + @barrel.image.width) / 2.0)
      neck_position = shell_offset.pivot_around_degrees(@zero, physical_rotation + @angle)
      @power_arrow_neck.position = neck_position + body_position
      @power_arrow_neck.image_rotation = @angle + physical_rotation - 90.0

      power_arrow_head_anchor = shell_offset + Vector.new(0.0, 7.0 - ((@power_arrow_neck.image.width) / 2.0))
      head_position = power_arrow_head_anchor.pivot_around_degrees(@zero, physical_rotation + @angle)
      @power_arrow_head.position = head_position + body_position
      @power_arrow_head.image_rotation = @angle + physical_rotation - 90.0

#      @game_state.manager(:render).debug(:point, :blue, :position => (head_position + body_position))
      life_percent = @life / INITIAL_LIFE
      self.color = @barrel.color = Color.new(1.0, life_percent, life_percent)
    end
    
#    join_to_physical @barrel, :joint => :basic, :anchor => Vector.new(0.0, 0.0)

    handle_event :adjust_angle do |message|
      next unless message.player == @player_id
      new_power = @angle + (message.value * ANGLE_ADJUSTMENT_FACTOR)
      @angle = new_power if new_power < 90.0 && new_power > -90.0
    end

    handle_event :adjust_power do |message|
      next unless message.player == @player_id
      new_power = @power + (message.value * POWER_ADJUSTMENT_FACTOR)
      if new_power < TOTAL_POWER && new_power > 10.0
        @power_changed = true if new_power != @power # @power_changed is used during update
        @power = new_power
      end
    end

    handle_event :fire do |message|
      next unless message.player == @player_id
      next unless @ready_to_fire
      shell = @game_state.create :Shell
      shell_offset = @barrel_anchor + Vector.new(0.0, -5.0 - (@barrel.image.width / 2.0))
      shell_position = shell_offset.pivot_around_degrees(@zero, physical_rotation + @angle)
      shell.body_position = body_position + shell_position
      shell.physical_rotation = physical_rotation + @angle + 90.0
      shell.add_force Vector.from_polar_vector(@power * POWER_FACTOR, @angle + physical_rotation)
      @game_state.manager(:sound).play_sound :fire_cannon
      reload_shot
    end

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

    on_physical_collided do |other_physical|
      next unless other_physical.other.has_tag? :damage
      @life -= other_physical.other.damage
      @game_state.remove self if @life < 1
    end

    reload_shot
  end

  def unload
    @game_state.remove @power_arrow_head
    @game_state.remove @power_arrow_neck
    @game_state.remove @barrel
  end

private
  def reload_shot
    @ready_to_fire = false
    add_countdown :shot, RELOAD_WARMPUP_IN_SECONDS, RELOAD_UPDATES_PER_SECOND
  end
end