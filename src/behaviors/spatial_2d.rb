class Spatial2D < Gemini::Behavior
  attr_accessor :x, :y, :width, :height
  wrap_with_callbacks :x=, :y=, :width=, :height=
  declared_methods :x, :y, :x=, :y=, :width, :width=, :height, :height=, :bounds
  
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
  
  def bounds
    return @bounds unless @bounds.nil?
    @bounds = Rectangle.new(@x, @y, @width, @height)
  end
end