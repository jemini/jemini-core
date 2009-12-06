# draws a line on the screen
class DrawableLine < Jemini::Behavior
  java_import 'org.newdawn.slick.geom.Line'
  java_import 'org.newdawn.slick.Color'
  depends_on :Spatial
  wrap_with_callbacks :draw

  #A Vector with the coordinates of the other end of the line.
  attr_reader :line_end_position
  #The Color to draw the line in.
  attr_accessor :color

  def load
    @color = Color.white
    @line_end_position = Vector.new(0.0, 0.0)
    @line = Line.new @game_object.position.to_slick_vector, @line_end_position.to_slick_vector
    @game_object.on_after_position_changes { set_line }
  end

  def line_end_position=(end_point)
    @line_end_position = end_point
    set_line
    @line_end_position
  end

  #Draw the line to the given graphics context.
  def draw(graphics)
    graphics.set_color @color
    graphics.draw @line
  end

private
  def set_line
    @line.set @game_object.position.to_slick_vector, @line_end_position.to_slick_vector
  end
end