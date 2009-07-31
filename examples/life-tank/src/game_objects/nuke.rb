require 'shell'

class Nuke < Shell

  has_behavior :PhysicalSprite
  has_behavior :Taggable
  has_behavior :TriangleTrailEmittable

  def load
    super
    @damage = 0
    set_bounded_image @game_state.manager(:render).get_cached_image(:nuke)
  end

  def explode(event)
    explosion = @game_state.create(:Explosion,
      :location => body_position,
      :duration => 0.3,
      :sound_volume => 1.5,
      :sound_pitch => 0.5,
      :damage => 45,
      :radius => 128.0,
      :force => 5000
    )
    @game_state.remove self
  end
  
end