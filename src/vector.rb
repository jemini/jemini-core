class Vector
  attr_reader :native_vector

  def dup
    self.new(x, y)
  end
  
  def self.from_polar_vector(magnitude, angle)
    w = Math.sin(Gemini::Math.degrees_to_radians(angle))
    h = -Math.cos(Gemini::Math.degrees_to_radians(angle))
    return new(w * magnitude, h * magnitude)
  end
  
  def initialize(x = 0.0, y = 0.0, z = nil)
    @native_vector = Java::org::newdawn::slick::geom::Vector2f.new(x, y)
  end
  
  def x
    @native_vector.x
  end
  
  def y
    @native_vector.y
  end
  
  def z
    @native_vector.z
  end
  
  def x=(new_x)
    @native_vector.x = new_x
  end
  
  def y=(new_y)
    @native_vector.y = new_y
  end
  
  def z=(new_z)
    @native_vector.z = new_z
  end
  
  def to_phys2d_vector
    Java::net::phys2d::math::Vector2f.new(@native_vector.x, @native_vector.y)
  end
  
  def distance_from(other_vector)
    (((x - other_vector.x) ** 2) + ((y - other_vector.y) ** 2)) ** (1.0 / 2.0)
  end
  
  def angle_from(other_vector)
    #TODO: Adding 90 degrees indicates to me that this is the wrong trig function.
    # Although it's good for perpendicular angles, which we'll need a method for.
    Gemini::Math.radians_to_degrees(Math.atan2(y - other_vector.y, x - other_vector.x)) + 90.0
  end
end

class Java::net::phys2d::math::Vector2f
  def to_vector
    Vector.new(x, y)
  end
  
  def to_phys2d_vector
    self
  end
end