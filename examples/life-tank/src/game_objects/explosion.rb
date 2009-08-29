class Explosion < Gemini::GameObject
  has_behavior :Magnetic
  has_behavior :Timeable
  has_behavior :Taggable

  attr_accessor :damage
  
  #Takes a hash with the following keys and values:
  #[:location] The vector with the explosion's x/y coordinates.
  #[:duration] How long the explosion lasts.  (Default 0.1 seconds.)
  #[:radius] Size of explosion.  (Default 64.0.)
  #[:damage] Maximum number of hit points taken from targets.  (Default 15.)
  #[:max_damage] The max damage possible - Damage scales up very fast if the distance is < 1, so use this to cap. (Default 15)
  #[:force] Maximum concussive force applied to targets.  (Default 1000.)
  #[:sound_volume]  (Default 1.0.)
  #[:sound_pitch]  (Default 1.0.)
  def load(options)
    options = {
      :duration => 0.1,
      :sound_volume => 1.0,
      :sound_pitch => 1.0,
      :damage => 150,
      :radius => 64.0,
      :force => -1000,
      :max_damage => 15
    }.merge(options)
    
    self.position = (options[:location])
    game_state.manager(:sound).play_sound :explosion, options[:sound_volume], options[:sound_pitch]
    
    smoke = game_state.create(:FadingImage, game_state.manager(:render).get_cached_image(:smoke), Color.new(:white), options[:duration] * 10.0)
    smoke.set_position position
    smoke.scale_image_from_original(options[:radius] / 64.0)
    
    add_countdown(:fade, options[:duration])
    on_countdown_complete do |name|
      @game_state.remove self if name == :fade
    end

#    add_tag :damage
    @damage            = options[:damage]
    @damage_max_radius = options[:radius]
    @max_damage        = options[:max_damage]
    @already_hit = []


    on_update do |delta|
      tanks = game_state.manager(:game_object).game_objects.select {|game_object| game_object.kind_of? Tank}
      tanks.each do |tank|
        distance = body_position.distance_from tank.body_position
        next if distance > @damage_max_radius
        next if @already_hit.include?(tank)
        splash_damage = @damage / (distance * Gemini::Math::SQUARE_ROOT_OF_TWO)
        splash_damage = @max_damage if splash_damage > @max_damage
        tank.life -= splash_damage
        @already_hit << tank
      end
    end
    
    self.magnetism = options[:force]
    self.magnetism_max_radius = options[:radius]
    self.magnetism_min_radius = 5.0
    
  end
  
end
