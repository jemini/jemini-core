require 'behaviors/drawable'

#Makes an object draw itself on the screen as a polygon.
class DrawableShape < Drawable
  java_import 'org.newdawn.slick.geom.Vector2f'
  java_import 'org.newdawn.slick.geom.Polygon'
  depends_on :Spatial
  attr_accessor :color, :image
  attr_reader :visual_shape


  #Set the shape to draw.
  #Accepts :Polygon or the name of a class in the DrawableShape namespace.
  #TODO: There are no DrawableShape::* classes yet!
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