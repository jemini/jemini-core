class Color
  attr_reader :native_color
  
  def initialize(red_or_other, blue = 0.0, green = 0.0, alpha = 0.0)
    if red_or_other.kind_of? Numeric
      @native_color = new_native_color(red_or_other, blue, green, alpha)
    else
      # create from predefined Slick colors
      #@native_color = "Java::org::newdawn::slick::Color::#{red_or_other.to_s.downcase}".constantize
      @native_color = Java::org::newdawn::slick::Color.send(red_or_other.to_s.downcase)
    end
  end
  
  def red
    @native_color.red_byte.to_f / 255
  end
  
  def blue
    @native_color.blue_byte.to_f / 255
  end
  
  def green
    @native_color.green_byte.to_f / 255
  end
  
  def alpha
    @native_color.alpha_byte.to_f / 255
  end
  
  def transparency
    1.0 - alpha
  end
  
  def red=(new_red)
    @native_color = new_native_color new_red, green, blue, alpha
  end
  
  def green=(new_green)
    @native_color = new_native_color red, new_green, blue, alpha
  end
  
  def blue=(new_blue)
    @native_color = new_native_color red, green, new_blue, alpha
  end
  
  def alpha=(new_alpha)
    @native_color = new_native_color red, green, blue, new_alpha
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
  private
  def new_native_color(red, blue, green, alpha)
    Java::org::newdawn::slick::Color.new(red, blue, green, alpha)
  end
end

class Object
  def clr(red_or_other, blue = 0.0, green = 0.0, alpha = 0.0)
    Color.new(red_or_other, blue, green, alpha)
  end
end