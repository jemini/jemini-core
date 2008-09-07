class Spatial < Gemini::Behavior
  attr_reader :x, :y
  wrap_with_callbacks :move
  declared_methods :x, :y, :move
  
  def load
    @x = 0
    @y = 0
  end
  
  def move(x, y)
    @x, @y = x, y
  end
end