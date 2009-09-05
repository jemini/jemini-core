#Gives an object x/y coordinates.
class Spatial < Jemini::Behavior
  wrap_with_callbacks :position=
  attr_accessor :position
  
  alias_method :set_position, :position=
  
  
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
  
  #Takes a Vector or x/y coordinates to move to.
#  def move(x_or_other, y=nil)
#    if y.nil?
#      #TODO: Determine if Spatial should really suppor this behavior.
#      # use case: Pipe a mouse move event directly to move
#      if x_or_other.kind_of? Jemini::Message
#        @position = Vector.new(x_or_other.value.x, x_or_other.value.y)
#      else
#        @position = Vector.new(x_or_other.x, x_or_other.y)
#      end
#    else
#      @position = Vector.new(x_or_other, y)
#    end
#  end
end