class Spatial2d < Gemini::Behavior
  attr_accessor :x, :y, :width, :height
  wrap_with_callbacks :x=, :y=, :width=, :height=
  declared_methods :x, :y, :x=, :y=, :width, :width=, :height, :height=, :bounds, :absolute_center_vector, :relative_center_vector
  
  def load
    @x = 0
    @y = 0
    @width = 0
    @height = 0
    @bounds = nil
  end
  
  def x=(value)
    @x = value
    @bounds = nil
  end
  
  def y=(value)
    @y = value
    @bounds = nil
  end
  
  def absolute_center_vector
    [x + (width / 2), y + (height / 2)]
  end
  
  def relative_center_vector
    [(width / 2), (height / 2)]
  end
  
  def bounds
    return @bounds unless @bounds.nil?
    @bounds = Rectangle.new(@x, @y, @width, @height)
  end
end