include_class "org.newdawn.slick.TrueTypeFont"
include_class "java.awt.Font"
require 'behaviors/drawable'

class Text < Gemini::GameObject
  has_behavior :Spatial
  PLAIN = Font::PLAIN
  ITALIC = Font::ITALIC
  BOLD = Font::BOLD
  
  attr_accessor :text, :size, :style, :font_name
  
  def load(x = 0, y = 0, text = "")
    move(x, y)
    @font_name = "Arial"
    @size = 12
    @text = text
    @style = PLAIN
    load_font
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
    raise "Invalid font style, must be PLAIN, ITALIC or BOLD" unless [PLAIN, ITALIC, BOLD].member? style
    @style = style
    load_font
  end
  alias_method :set_style, :style=
  
private
  def load_font
    @font = TrueTypeFont.new(Font.new(@font_name, @style, @size), true)
  end
end