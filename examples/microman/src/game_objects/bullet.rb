class Bullet < Gemini::GameObject
  has_behavior :TangibleSprite
  
  def load
    bullet_image = @game_state.manager(:render).get_cached_image(:bullet)
    set_gravity_effected false
    set_bounded_image bullet_image
    set_mass 10
  end
end