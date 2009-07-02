#Makes an object attract other Physical game objects towards it.
class Explosion < Gemini::GameObject
  has_behavior :Repulsive
  has_behavior :Timeable
  has_behavior :Taggable
  
  #Takes a Vector with the starting x/y coordinates.
  def load(location)
    
    self.move(location)
    self.game_state.manager(:sound).play_sound :explosion
    
    smoke = self.game_state.create(:FadingImage, self.game_state.manager(:render).get_cached_image(:smoke), Color.new(:white), 1.0)
    smoke.set_position self.position
    
    add_countdown(:fade, 0.1)
    
    on_countdown_complete do |name|
      @game_state.remove self if name == :fade
    end
    
  end
  
end
