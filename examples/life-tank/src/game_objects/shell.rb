class Shell < Gemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :Taggable

  attr_accessor :damage

  def load
    add_tag :damage
    @damage = 10
    set_bounded_image @game_state.manager(:render).get_cached_image(:shell)
    set_mass 1
    on_physical_collided do
      @game_state.remove_game_object self
    end
  end
end