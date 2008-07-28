class Spatial2D < Gemini::Behavior
  attr_accessor :x, :y, :width, :height
  wrap_with_callbacks :x=, :y=, :width=, :height=
  declared_methods :x, :y, :x=, :y=, :width, :width=, :height, :height=
  
  def load
    @x = 0
    @y = 0
    @width = 0
    @height = 0
  end
end