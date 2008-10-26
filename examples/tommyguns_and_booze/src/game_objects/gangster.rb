class Gangster < Gemini::GameObject
  has_behavior :CardinalMovable
  has_behavior :TangibleSprite
  
  def load
    set_bounded_image "gangster.png"
    set_damping 0.6
    
    behavior_event_alias :CardinalMovable, :start_move do |message|
      case message.value
      when :up
        message.value = CardinalMovable::NORTH
      when :down
        message.value = CardinalMovable::SOUTH
      when :right
        message.value = CardinalMovable::EAST
      when :left
        message.value = CardinalMovable::WEST
      end
      :begin_cardinal_movement
    end
    
    behavior_event_alias :CardinalMovable, :stop_move do |message|
      case message.value
      when :up
        message.value = CardinalMovable::NORTH
      when :down
        message.value = CardinalMovable::SOUTH
      when :right
        message.value = CardinalMovable::EAST
      when :left
        message.value = CardinalMovable::WEST
      end
      :end_cardinal_movement
    end
  end
end