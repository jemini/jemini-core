class Color
  SlickColor = Java::org::newdawn::slick::Color
  attr_reader :native_color
  
  def initialize(red_or_other, blue = nil, green = nil, alpha = 1.0)
    if from_hex?(red_or_other, green, blue)
      from_hex(red_or_other)
    elsif from_rgba?(red_or_other, blue, green)
      from_rgba(red_or_other, blue, green, alpha)
    elsif red_or_other.is_a? SlickColor
      @native_color = red_or_other
    else
      from_word(red_or_other)
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
    self.class.new @native_color.darker amount
  end
  
  def darken_by!(amount)
    @native_color = @native_color.darker amount
  end
  
  def fade_by(amount)
    self.alpha = alpha * (1.0 - amount)
  end

private
  def from_hex?(red, green, blue)
    red.is_a?(Numeric) && green.nil? && blue.nil? #alpha defaults to 1.0
  end

  def from_hex(hex)
    @native_color = SlickColor.new(hex)
  end

  def from_rgba?(red, blue, green)
    red.is_a?(Numeric) && !blue.nil? && !green.nil?
  end

  def from_rgba(red, blue, green, alpha)
    @native_color = SlickColor.new(red, blue, green, alpha)
  end

  def from_word(word)
    # create from predefined Slick colors
    fixed_color = SlickColor.send(word.to_s.downcase)
    # we don't want to change the original, so we copy it
    @native_color = SlickColor.new(fixed_color.r, fixed_color.g, fixed_color.b, fixed_color.a)
  end
end