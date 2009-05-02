class Tank < Gemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :RecievesEvents

  ANGLE_ADJUSTMENT_FACTOR = 1.5
  POWER_ADJUSTMENT_FACTOR = 1.0

  def load
    set_bounded_image @game_state.manager(:render).get_cached_image(:tank_body)
    set_friction 0.9
    @angle = 45.0
    @power = 50.0

    @barrel = @game_state.create_game_object(:Turret)
    @barrel_anchor = Vector.new 0.0, -((image.height.to_f * 3.0 / 4.0) + (@barrel.image.height.to_f / 2.0))
    @zero = Vector.new(0.0, 0.0)
    on_update do
      offset_above_tank = @barrel_anchor.pivot_around_degrees(@zero, physical_rotation)
      barrel_position = offset_above_tank.pivot_around_degrees(@zero, @angle)
      @barrel.position = barrel_position + body_position
      @game_state.manager(:render).debug(:point, :red, :position => (body_position))
      @game_state.manager(:render).debug(:point, :green, :position => (barrel_position + body_position))
      @game_state.manager(:render).debug(:point, :yellow, :position =>  (@barrel_anchor + body_position))
      @barrel.image_rotation = @angle + physical_rotation - 90.0
    end
    
#    join_to_physical @barrel, :joint => :basic, :anchor => Vector.new(0.0, 0.0)

    handle_event :adjust_angle do |message|
      new_power = @angle + (message.value * ANGLE_ADJUSTMENT_FACTOR)
      @angle = new_power if new_power < 90.0 && new_power > -90.0
    end

    handle_event :adjust_power do |message|
      new_power = @power + (message.value * POWER_ADJUSTMENT_FACTOR)
      @power = new_power if new_power < 100.0 && new_power > 10.0
#      rotate_physical message.value
    end

    handle_event :fire do
      puts "FIRE!"
    end
  end
end