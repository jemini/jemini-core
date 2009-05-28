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
      @game_state.manager(:sound).play_sound :shell_explosion
      @game_state.create_smoke_at body_position
      @game_state.remove self
    end

    on_update do
      self.physical_rotation = velocity.polar_angle_degrees
    end
  end
end