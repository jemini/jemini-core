# draws a line on the screen
class DrawableEllipse < Jemini::Behavior
  java_import 'org.newdawn.slick.geom.Ellipse'
  depends_on :Spatial
  wrap_with_callbacks :draw

  #The Color to draw the ellipse in.
  attr_accessor :color
  #If true, the shape will be drawn filled in.  If false, only the frame will be drawn.
  attr_accessor :ellipse_filled

  def load
    @color = Color.new :white
    @ellipse_filled = true
    @ellipse = Ellipse.new @game_object.position.x, @game_object.position.y, 1.0, 1.0
    @game_object.on_after_position_changes { set_drawing_location }
  end

  #The ellipse height.
  def height=(value)
    @ellipse.radius2 = value / 2.0
    set_drawing_location
  end
  def height
    @ellipse.radius2 * 2.0
  end

  #The ellipse width.
  def width=(value)
    @ellipse.radius1 = value / 2.0
    set_drawing_location
  end
  def width
    @ellipse.radius1 * 2.0
  end
  
  #Draw an outline to the given graphics context.
  def draw(graphics)
    graphics.set_color @color.native_color
    if @ellipse_filled
      graphics.fill @ellipse
    else
      graphics.draw @ellipse
    end
  end
  
private
  def set_drawing_location
    @ellipse.x = @game_object.position.x - @ellipse.radius1
    @ellipse.y = @game_object.position.y - @ellipse.radius2
  end
end