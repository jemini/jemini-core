class Tank < Gemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :RecievesEvents

  ANGLE_ADJUSTMENT_FACTOR = 1.5
  POWER_ADJUSTMENT_FACTOR = 1.0
  TOTAL_POWER = 100.0
  
  def load
    set_bounded_image @game_state.manager(:render).get_cached_image(:tank_body)
    set_friction 0.9
    @angle = 45.0
    @power = 50.0

    @zero = Vector.new(0.0, 0.0)

    @barrel = @game_state.create_game_object(:Turret)
    @barrel_anchor = Vector.new 0.0, -((image.height.to_f * 3.0 / 4.0))

    @power_arrow_neck = @game_state.create_game_object(:PowerArrowNeck)
    @power_arrow_head = @game_state.create_game_object(:PowerArrowHead)

    @power_changed = true # to set the proper scale on the first update, flag as true
    
    on_update do
      barrel_position = @barrel_anchor.pivot_around_degrees(@zero, physical_rotation + @angle)
      @barrel.position = barrel_position + body_position
      @barrel.image_rotation = @angle + physical_rotation - 90.0

      if @power_changed
        width_factor = 2 * @power / 100.0
        @power_arrow_neck.scale_image_from_original width_factor, 1.0
      end
      
      power_arrow_neck_anchor = @barrel_anchor + Vector.new(0.0, -(@power_arrow_neck.image.width + @barrel.image.width) / 2.0)
      neck_position = power_arrow_neck_anchor.pivot_around_degrees(@zero, physical_rotation + @angle)
      @game_state.manager(:render).debug(:point, :red, :position => (neck_position + body_position))
      @power_arrow_neck.position = neck_position + body_position
      @power_arrow_neck.image_rotation = @angle + physical_rotation - 90.0

      power_arrow_head_anchor = power_arrow_neck_anchor + Vector.new(0.0, 7.0 - ((@power_arrow_neck.image.width) / 2.0))
      head_position = power_arrow_head_anchor.pivot_around_degrees(@zero, physical_rotation + @angle)
      @game_state.manager(:render).debug(:point, :blue, :position => (head_position + body_position))
      @power_arrow_head.position = head_position + body_position
      @power_arrow_head.image_rotation = @angle + physical_rotation - 90.0
    end
    
#    join_to_physical @barrel, :joint => :basic, :anchor => Vector.new(0.0, 0.0)

    handle_event :adjust_angle do |message|
      new_power = @angle + (message.value * ANGLE_ADJUSTMENT_FACTOR)
      @angle = new_power if new_power < 90.0 && new_power > -90.0
    end

    handle_event :adjust_power do |message|
      new_power = @power + (message.value * POWER_ADJUSTMENT_FACTOR)
      if new_power < TOTAL_POWER && new_power > 10.0
        @power_changed = true if new_power != @power # @power_changed is used during update
        @power = new_power
      end
    end

    handle_event :fire do |message|
      puts "FIRE!"
    end
  end
end