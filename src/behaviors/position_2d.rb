class Position2D < Gemini::Behavior
  declared_methods :x, :y, :x=, :y=
  attr_accessor :x, :y
  
  def load
    @x = 0
    @y = 0
  end
end