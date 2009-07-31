class Explosion < Gemini::GameObject
  has_behavior :Magnetic
  has_behavior :Timeable
  has_behavior :Taggable

  attr_accessor :damage
  
  def load(location)
    
    move(location)
    game_state.manager(:sound).play_sound :explosion
    
    smoke = game_state.create(:FadingImage, game_state.manager(:render).get_cached_image(:smoke), Color.new(:white), 1.0)
    smoke.set_position position
    
    add_countdown(:fade, 0.1)
    
    on_countdown_complete do |name|
      @game_state.remove self if name == :fade
    end

    add_tag :damage
    @damage = 15
    @damage_max_radius = 80
    @already_hit = []
    on_update do |delta|
      tanks = game_state.manager(:game_object).game_objects.select {|game_object| game_object.kind_of? Tank}
      tanks.each do |tank|
        distance = position.distance_from tank
        next if distance > @damage_max_radius
        next if @already_hit.include?(tank)
        tank.life -= delta * @damage / (distance * Gemini::Math::SQUARE_ROOT_OF_TWO)
        @already_hit << tank
      end
    end
    
  end
  
end
