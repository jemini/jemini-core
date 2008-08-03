class Clickable < Gemini::Behavior
  depends_on :BoundingBoxCollidable
  wrap_with_callbacks :click
  
  def load
    preferred_collision_check BoundingBoxCollidable::TAGS
    @target.on_collided do |event, continue|
      puts "collided with something, was it clicking? #{event.other.clicking?}"
      if event.other.respond_to? :clicking? && event.other.clicking?
        click
      end
    end
  end
  
  def click; end
end