# draws a line on the screen
# TODO: Enable color
class DrawableLine < Jemini::Behavior
  java_import 'org.newdawn.slick.geom.Line'
  depends_on :Spatial
  wrap_with_callbacks :draw

  attr_reader :line_end_position
  attr_accessor :color

  def load
    @line_end_position = Vector.new(0.0, 0.0)
    @line = Line.new @game_object.position.to_slick_vector, @line_end_position.to_slick_vector
    @game_object.on_after_position_changes { set_line }
    #@color = Color.white
  end

  def line_end_position=(end_point)
    @line_end_position = end_point
    set_line
    @line_end_position
  end

  def draw(graphics)
    graphics.draw @line
  end

private
  def set_line
    @line.set @game_object.position.to_slick_vector, @line_end_position.to_slick_vector
  end
end