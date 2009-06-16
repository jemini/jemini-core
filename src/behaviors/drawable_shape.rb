require 'behaviors/drawable'

class DrawableShape < Drawable
  include_class 'org.newdawn.slick.geom.Vector2f'
  include_class 'org.newdawn.slick.geom.Polygon'
  depends_on :Spatial
  attr_accessor :color, :image
  attr_reader :visual_shape

  def load
    $u = 0.0
    $v = 0.0
  end

  def set_visual_shape(shape, *params)
    if shape == :polygon || shape == :Polygon
      @visual_shape = "#{self.class}::#{shape}".constantize.new
      params.each do |vector|
        @visual_shape.add_point vector.x, vector.y
      end
    else
      @visual_shape = ("DrawableShape::"+ shape.to_s).constantize.new(params)
    end
  end
  
  def image=(image)
    @image = image
    puts "width: #{@image.width}, height: #{@image.height}"
    puts "width / screen width: #{@image.width.to_f / @target.game_state.screen_width.to_f}"
    puts "1/width: #{1.0 / @image.width.to_f}"
  end
  alias_method :set_image, :image=

  def draw(graphics)
    if @visual_shape.kind_of? Polygon
      #TODO: Tweak these values!!!!
      #@image.width.to_f / @target.game_state.screen_width.to_f, @image.height.to_f / @target.game_state.screen_height.to_f
      graphics.texture @visual_shape, @image, 1.0 / @image.width.to_f, 1.0 / @image.height.to_f
    else
      raise "#{@visual_shape.class} is not supported"
    end
  end
end