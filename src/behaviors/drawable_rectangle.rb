# draws a line on the screen
class DrawableRectangle < Jemini::Behavior
  java_import 'org.newdawn.slick.geom.Rectangle'
  java_import 'org.newdawn.slick.Color'
  depends_on :Spatial
  wrap_with_callbacks :draw

  #The Color to draw the shape in.
  attr_accessor :color
  #If true, the shape will be drawn filled in.  If false, only the frame will be drawn.
  attr_accessor :rectangle_filled

  def load
    @color = Color.white
    @rectangle_filled = true
    @rectangle = Rectangle.new @game_object.position.x, @game_object.position.y, 1.0, 1.0
    @game_object.on_after_position_changes { set_drawing_location }
  end

  #The rectangle height.
  def height=(value)
    @rectangle.height = value
    set_drawing_location
  end
  def height
    @rectangle.height
  end

  #The rectangle width.
  def width=(value)
    @rectangle.width = value
    set_drawing_location
  end
  def width
    @rectangle.width
  end
  
  #Draw an outline to the given graphics context.
  def draw(graphics)
    graphics.set_color @color
    if @rectangle_filled
      graphics.fill @rectangle
    else
      graphics.draw @rectangle
    end
  end
  
private
  def set_drawing_location
    @rectangle.x = @game_object.position.x - (@rectangle.width / 2.0)
    @rectangle.y = @game_object.position.y - (@rectangle.height / 2.0)
  end
end