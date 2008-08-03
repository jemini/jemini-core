class Pointer < Gemini::Behavior
  depends_on :BoundingBoxCollidable
  depends_on :Sprite
  declared_methods :clicking?

  def load
    add_tag :ui, :gui, :pointer
    preferred_collision_check BoundingBoxCollidable::TAGS
    collides_with_tags :gui
    require 'message_queue'
    Gemini::MessageQueue.instance.add_listener(:slick_input, self) do |type, message|
      input_type = message[0]
      input_data = message[1]
      case input_type
      when :mouseMoved
        move(input_data[2], input_data[3])
      when :mousePressed
        start_click
      when :mouseReleased
        stop_click
      end
      #puts "input in button!"
      #puts "#{input_type.inspect} - #{message[1].inspect}"
    end
  end
  
  def clicking?
    @clicking
  end
  
  def start_click
    @clicking = true
  end
  
  def stop_click
    @clicking = false
  end
end