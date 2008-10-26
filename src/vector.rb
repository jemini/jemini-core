class Vector
  attr_reader :native_vector
  
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
end

class Java::net::phys2d::math::Vector2f
  def to_vector
    Vector.new(x, y)
  end
end