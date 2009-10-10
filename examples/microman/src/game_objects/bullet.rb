class Bullet < Jemini::GameObject
  has_behavior :TangibleSprite
  
  def load
    bullet_image = :bullet
    set_gravity_effected false
    set_bounded_image bullet_image
    set_mass 10
    on_collided do
      fading_bullet = game_state.create_game_object(:FadingImage, image, color, 1.5)
      fading_bullet.add_behavior :TangibleSprite
      # this should not be the right thing to do
      game_state.manager(:physics).send(:add_to_world, fading_bullet)
      fading_bullet.set_bounded_image image
      fading_bullet.move x, y
      fading_bullet.set_restitution 0.5
      fading_bullet.set_velocity velocity
      fading_bullet.set_mass 1
      fading_bullet.set_gravity_effected true
      game_state.remove_game_object self
    end
  end
end