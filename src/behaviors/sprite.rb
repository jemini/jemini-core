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
    self.width = @image.width
    self.height = @image.height
  end
  
  def draw
    @image.draw(x, y)
  end
end