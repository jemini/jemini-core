class Position2D < Gemini::Behavior
  attr_accessor :x, :y
  wrap_with_callbacks :x=, :y=
  declared_methods :x, :y, :x=, :y=
  
  def load
    @x = 0
    @y = 0
  end
  
  def x=(value)
    @x = value
  end
  
  def y=(value)
    @y = value
  end
end