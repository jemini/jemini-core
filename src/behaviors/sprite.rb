class Sprite < Gemini::Behavior
  include_class 'org.newdawn.slick.Image'
  declared_methods :draw, :image, :image=
  attr_accessor :image

  def image=(sprite_name)
    if sprite_name.kind_of? Image
      @image = sprite_name
    else
      @image = Image.new("data/#{sprite_name}")
    end
  end
  
  def draw
    @image.draw(x, y)
  end
end
