class ShellShooter < Gemini::Behavior
  POWER_FACTOR = 120.0
  
  def fire_weapon(power, angle)
    #TODO: configurable fire_from_distance to replace barrel anchor
    shell = @target.game_state.create :Shell
#    shell_offset =  @target.barrel_anchor + Vector.new(0.0, -5.0 + @target.barrel_anchor.y)
    shell_offset =  Vector.new(0.0, -5.0 - @target.barrel_width)
    shell_position = shell_offset.pivot_around_degrees(Vector::ORIGIN, @target.physical_rotation + angle)
    shell.body_position = @target.body_position + shell_position
    shell.physical_rotation = @target.physical_rotation + angle + 90.0
    shell_vector = Vector.from_polar_vector(power * POWER_FACTOR, angle + @target.physical_rotation)
    shell.add_force shell_vector
    @target.game_state.manager(:sound).play_sound :fire_cannon
    @target.add_force shell_vector.negate
  end
end