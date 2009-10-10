require 'shell'

class RollingMine < Shell

  has_behavior :PhysicalSprite
  has_behavior :Taggable

  def load
    @damage = 0
    set_mass 1
    set_bounded_image :rolling_mine
    set_shape :Circle, image.width / 2.0
    on_physical_collided do |event|
      explode(event) if event.other.kind_of?(Tank) or event.other.kind_of?(TankWheel)
    end
    add_tag :damage
  end

  def explode(event)
    explosion = game_state.create(:Explosion,
      :location => body_position,
      :sound_volume => 0.8,
      :sound_pitch => 1.2,
      :damage => 15,
      :radius => 32.0,
      :force => 500.0
    )
    game_state.remove self
  end
  
end