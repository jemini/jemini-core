# TODO: Remove reliance on Slick's vector
class Vector
  SlickVector = Java::org::newdawn::slick::geom::Vector2f
  
  attr_reader :native_vector

  def self.from_polar_vector(magnitude, angle)
    w = Math.sin(Gemini::Math.degrees_to_radians(angle))
    h = -Math.cos(Gemini::Math.degrees_to_radians(angle))
    return new(w * magnitude, h * magnitude)
  end

  def initialize(x = 0.0, y = 0.0, z = nil)
    @native_vector = SlickVector.new(x, y)
  end

  ORIGIN = new(0.0, 0.0).freeze

  def dup
    self.class.new(x, y)
  end

  # often used for center calculations. Other multiples are not needed
  def half
    Vector.new(x / 2.0, y / 2.0)
  end

  def ==(other_vector)
    return false unless other_vector.respond_to?(:x) || other_vector.respond_to?(:y)
    x == other_vector.x && y == other_vector.y
  end

  def +(other_vector)
    self.class.new(x + other_vector.x, y + other_vector.y)
  end

  def -(other_vector)
    self.class.new(x - other_vector.x, y - other_vector.y)
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

  def midpoint_of(other_vector)
    Vector.new((x + other_vector.x) / 2.0, (y + other_vector.y) / 2.0)
  end

  def pivot_around_degrees(other_vector, rotation)
    pivot_around(other_vector, Gemini::Math.degrees_to_radians(rotation))
  end
  
  def pivot_around(other_vector, rotation)
    diff_x = x - other_vector.x
    diff_y = y - other_vector.y
    sine  = Math.sin(rotation)
    cosine = Math.cos(rotation)
    rotated_x = (cosine * diff_x) - (sine * diff_y)
    rotated_y = (sine * diff_x) + (cosine * diff_y)
    self.class.new rotated_x, rotated_y
  end

  def polar_angle
    Math.atan2(y, x)
  end

  def polar_angle_degrees
    Gemini::Math.radians_to_degrees polar_angle
  end

  def magnitude
    Math::sqrt((x ** 2) + (y ** 2))
  end

  # TODO: Implement -@ and +@, the negate and plus(?) unary operators
  def negate
    self.class.new(-x, -y)
  end

  def near?(other_vector, radius)
    distance_from(other_vector) <= radius
  end

  def to_s
    "<#{self.class} - X: #{x} Y: #{y}>"
  end
end

class Java::net::phys2d::math::Vector2f
  def +(other_vector)
    Vector.new(x + other_vector.x, y + other_vector.y)
  end

  def to_vector
    Vector.new(x, y)
  end
  
  def to_phys2d_vector
    self
  end
end