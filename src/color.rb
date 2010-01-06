class Color
  SlickColor = Java::org::newdawn::slick::Color
  attr_reader :native_color
  
  def initialize(red_or_other, blue = nil, green = nil, alpha = 1.0)
    if red_or_other.kind_of? Numeric
      if green.nil? && blue.nil? #alpha defaults to 1.0
        @native_color = SlickColor.new(red_or_other)
      else
        @native_color = SlickColor.new(red_or_other, blue, green, alpha)
      end
    else
      # create from predefined Slick colors
      fixed_color = SlickColor.send(red_or_other.to_s.downcase)
      # we don't want to change the original, so we copy it
      @native_color = SlickColor.new(fixed_color.r, fixed_color.g, fixed_color.b, fixed_color.a)
    end
  end
  
  def red
    @native_color.r
  end
  
  def blue
    @native_color.b
  end
  
  def green
    @native_color.g
  end
  
  def alpha
    @native_color.a
  end
  
  def transparency
    1.0 - alpha
  end
  
  def red=(new_red)
    @native_color.r = new_red
  end
  
  def green=(new_green)
    @native_color.g = new_green
  end
  
  def blue=(new_blue)
    @native_color.b = new_blue
  end
  
  def alpha=(new_alpha)
    @native_color.a = new_alpha
  end
  
  def transparency=(new_transparency)
    self.alpha = 1.0 - new_transparency
  end
  
  def darken_by(amount)
    @native_color.darken amount
  end
  
  def darken_by!(amount)
    @native_color = @native_color.darken amount
  end
  
  def fade_by(amount)
    self.alpha = alpha * (1.0 - amount)
  end
end