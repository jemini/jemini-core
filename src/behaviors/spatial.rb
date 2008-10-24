class Spatial < Gemini::Behavior
  attr_accessor :x, :y
  wrap_with_callbacks :move
  declared_methods :x, :x=, :y, :y=, :move
  
  def load
    @x = 0
    @y = 0
  end
  
  def move(x_or_other, y=nil)
    if y.nil?
      if x_or_other.kind_of? Vector
        @x = x_or_other.x
        @y = x_or_other.y
      #TODO: Determine if Spatial should really suppor this behavior.
      # use case: Pipe a mouse move event directly to move
      elsif x_or_other.kind_of? Gemini::Message
        @x = x_or_other.value.x
        @y = x_or_other.value.y
      else
        raise "move does not support #{x_or_other.class}"
      end
    else
      @x, @y = x_or_other, y
    end
  end
end