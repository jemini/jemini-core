class Spatial < Gemini::Behavior
  attr_accessor :position
  wrap_with_callbacks :move
  declared_methods :x, :x=, :y, :y=, :move, :position
  
  def load
    @position = Vector.new(0,0)
  end

  def x
    @position.x
  end
  
  def y
    @position.y
  end
  
  def x=(x)
    @position.x = x
  end
  
  def y=(y)
    @position.y = y
  end
  
  def move(x_or_other, y=nil)
    if y.nil?
      if x_or_other.kind_of? Vector
        @position = Vector.new(x_or_other.x, x_or_other.y)
      #TODO: Determine if Spatial should really suppor this behavior.
      # use case: Pipe a mouse move event directly to move
      elsif x_or_other.kind_of? Gemini::Message
        @position = Vector.new(x_or_other.value.x, x_or_other.value.y)
      else
        raise "move does not support #{x_or_other.class}"
      end
    else
      @position = Vector.new(x_or_other, y)
    end
  end
end