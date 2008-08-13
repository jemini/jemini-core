class Pointer < Gemini::Behavior
  depends_on :BoundingBoxCollidable
  depends_on :Sprite
  depends_on :Movable2d

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
    end
    
    on_collided do |event, continue|
      event.collided_object.click if event.collided_object.respond_to? :click
    end
  end
  
  def start_click
    Tags.find_by_all_tags(:gui).each {|collidable| collision_check collidable }
    @clicking = true
  end
  
  def stop_click
    
  end
end