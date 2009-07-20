class Explosion < Gemini::GameObject
  has_behavior :Magnetic
  has_behavior :Timeable
  has_behavior :Taggable
  
  def load(location)
    
    move(location)
    game_state.manager(:sound).play_sound :explosion
    
    smoke = game_state.create(:FadingImage, game_state.manager(:render).get_cached_image(:smoke), Color.new(:white), 1.0)
    smoke.set_position position
    
    add_countdown(:fade, 0.1)
    
    on_countdown_complete do |name|
      @game_state.remove self if name == :fade
    end
    
  end
  
end
