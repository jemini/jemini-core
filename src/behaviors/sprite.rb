class Sprite < Gemini::Behavior
  include_class 'org.newdawn.slick.Image'
  depends_on :Spatial2d
  declared_methods :draw, :image, :image=, :image_scaling
  attr_accessor :image
  
  def image=(sprite_name)
    if sprite_name.kind_of? Image
      @image = sprite_name
    else
      @image = Image.new("data/#{sprite_name}")
    end
    set_spatial_properties
  end
  
  def image_scaling(x_scale, y_scale = nil)
    y_scale = x_scale if y_scale.nil?
    @image = @image.get_scaled_copy(x_scale.to_f * width, y_scale.to_f * height)
    set_spatial_properties
  end
  
  def draw
    @image.draw(x, y)
  end

private
  def set_spatial_properties
    self.width = @image.width
    self.height = @image.height
  end
end