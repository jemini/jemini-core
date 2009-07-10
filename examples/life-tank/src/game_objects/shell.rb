class Shell < Gemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :Taggable
  has_behavior :TriangleTrailEmittable
  
  attr_accessor :damage

  def load
    add_tag :damage
    @damage = 33
    set_bounded_image @game_state.manager(:render).get_cached_image(:shell)
    set_mass 1
    
    emit_triangle_trail_with_radius(image.height / 2)
    
    on_physical_collided do |event|
      explosion = @game_state.create :Explosion, body_position
      explosion.magnetism = 1000.0
      explosion.magnetism_max_radius = 80.0
      explosion.magnetism_min_radius = 5.0
      @game_state.remove self
    end

    on_update do
      self.physical_rotation = velocity.polar_angle_degrees
    end
  end
end