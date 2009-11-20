class Text < Jemini::GameObject
  java_import "org.newdawn.slick.TrueTypeFont"
  java_import "java.awt.Font"
  
  has_behavior :Spatial
  
  attr_accessor :text, :size, :style, :font_name
  
  def load(text, options={})
    @font_name = options[:name] || "Arial"
    @size      = options[:size] || 12
    @text      = text
    @style     = get_style(options[:style])
    load_font
    orient_text(options)
  end

  def text_width
    @font.get_width(@text)
  end

  def text_height
    @font.get_height(@text)
  end
  
  def draw(graphics)
    half_width  = @font.get_width(@text) / 2
    half_height = @font.get_height(@text) / 2
    @font.draw_string(x - half_width , y - half_height, @text)
  end

  def font_name=(name)
    @font_name = name
    load_font
  end
  alias_method :set_font_name, :font_name=
  
  def size=(size)
    @size = size
    load_font
  end
  alias_method :set_size, :size=
  
  def style=(style)
    raise "Invalid font style #{style.inspect}, must be :bold, :italic or :plain" unless [:bold, :italic, :plain].member? style
    @style = get_style(style)
    load_font
  end
  alias_method :set_style, :style=
  
private
  def orient_text(options)
    case options[:justify]
    when :top_left
      self.position = options[:position] + Vector.new(text_width, text_height).half if options[:position]
    when :bottom_right
      self.position = options[:position] - Vector.new(text_width, text_height).half if options[:position]
    when :center, nil
      self.position = options[:position] if options[:position]
    end
  end

  def load_font
    @font = TrueTypeFont.new(Font.new(@font_name, @style, @size), true)
  end

  def get_style(style)
    case style
    when :bold
      Font::BOLD
    when :italic
      Font::ITALIC
    when :plain, nil
      Font::PLAIN
    end
  end
end