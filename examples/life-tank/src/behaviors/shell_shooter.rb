class ShellShooter < Jemini::Behavior
  POWER_FACTOR = 120.0
  
  def fire_weapon(power, angle)
    #TODO: configurable fire_from_distance to replace barrel anchor
    shell = game_state.create :Shell
#    shell_offset =  @game_object.barrel_anchor + Vector.new(0.0, -5.0 + @game_object.barrel_anchor.y)
    shell_offset =  Vector.new(0.0, -5.0 - @game_object.barrel_width)
    shell_position = shell_offset.pivot_around_degrees(Vector::ORIGIN, @game_object.physical_rotation + angle)
    shell.body_position = @game_object.body_position + shell_position
    shell.physical_rotation = @game_object.physical_rotation + angle + 90.0
    shell_vector = Vector.from_polar_vector(power * POWER_FACTOR, angle + @game_object.physical_rotation)
    shell.add_force shell_vector
    game_state.manager(:sound).play_sound :fire_cannon
    @game_object.add_force shell_vector.negate
  end
end