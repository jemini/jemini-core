class Shell < Jemini::GameObject
  has_behavior :PhysicalSprite
  has_behavior :Taggable
  has_behavior :TriangleTrailEmittable
  
  attr_accessor :damage
  @@active_shells = []

  VELOCITY_TO_DAMAGE_RATIO = 0.05

  def load
    # @@active_shells.each {|other_shell| add_excluded_physical other_shell}
    # @@active_shells << self
    add_tag :damage
    @damage = 8
    set_bounded_image :shell
    set_mass 1
    
    emit_triangle_trail_with_radius(image.height / 2)
    
    on_physical_collided do |event|
      #explode(event)
      explode(event) unless event.other.kind_of?(Shell)
    end
    on_update :align_shell
  end

  def align_shell(delta)
    self.physical_rotation = velocity.polar_angle_degrees
  end

  def explode(event)
    explosion = game_state.create(:Explosion, :location => body_position)
    game_state.remove self
  end

  def damage
    @damage + (VELOCITY_TO_DAMAGE_RATIO * velocity.magnitude.abs)
  end

  def unload
    # @@active_shells.delete self
  end
end