class TankWheel < Gemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :Taggable
  
  TURN_RATE = 0.1
  
  def load(tank)
    @tank = tank
    set_image @game_state.manager(:render).get_cached_image(:tank_wheel)
    set_shape :Circle, image.width / 2.0
    set_friction 2000000.0
    set_mass 5.0
    set_angular_damping 50.0
    set_angular_velocity 0.0
    set_restitution 1.0
    on_physical_collided {|e| @tank.take_damage e}
  end

  def turn(power)
    apply_angular_velocity power * TURN_RATE
  end
end