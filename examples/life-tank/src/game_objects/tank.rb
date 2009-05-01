class Tank < Gemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :RecievesEvents

  ANGLE_ADJUSTMENT_FACTOR = 1.5
  POWER_ADJUSTMENT_FACTOR = 1.0

  def load
    set_bounded_image @game_state.manager(:render).get_cached_image(:tank_body)
    set_friction 0.9
    @angle = 90.0
    @power = 50.0

    @barrel_offset = Vector.new(0, image.height.to_f / 2.0)

    @barrel = @game_state.create_game_object(:Turret)
    #on_update { @barrel.body_position = (@barrel_offset + body_position).pivot_around(body_position, body_rotation) }
    join_to_physical @barrel, :joint => :basic, :anchor => Vector.new(0.0, 0.0)

    handle_event :adjust_angle do |message|
      new_power = @angle + (message.value * ANGLE_ADJUSTMENT_FACTOR)
      @angle = new_power if new_power < 180.0 && new_power > 0.0
    end

    handle_event :adjust_power do |message|
      new_power = @power + (message.value * POWER_ADJUSTMENT_FACTOR)
      @power = new_power if new_power < 100.0 && new_power > 10.0
      puts "power: #{@power}"
    end

    handle_event :fire do
      puts "FIRE!"
    end


  end
end