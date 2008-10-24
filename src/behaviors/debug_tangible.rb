require 'behaviors/drawable'
class DebugTangible < Drawable
  #declared_methods :draw
  PhysVector = Java::net::phys2d::math::Vector2f
  SlickVector = Java::org::newdawn::slick::geom::Vector2f
  
  def load
    @target.game_state.manager(:render).on_after_render do |graphics|
      draw(graphics)
    end
  end
  
  def unload
    # Remove listener for after render
  end
  
  def draw(graphics)
    #TODO: Support joints and composite bodies(?)
    body = @target.instance_variable_get(:@behaviors)[:Tangible].instance_variable_get(:@body)
    physics_shape = body.shape
    graphics_shape = if physics_shape.kind_of?(Java::net::phys2d::raw::shapes::Box)
                       Java::org.newdawn.slick.geom.Polygon.new(physics_shape.get_points(body.position, body.rotation).map{|point| [point.x, point.y]}.flatten.to_java(:float))
                     elsif physics_shape.kind_of?(Java::net.phys2d.raw.shapes.Polygon)
                       Java::org.newdawn.slick.geom.Polygon.new(physics_shape.get_vertices(body.position, body.rotation).map{|point| [point.x, point.y]}.flatten.to_java(:float))
                     elsif physics_shape.kind_of? Java::net.phys2d.raw.shapes.Circle
                       Java::org.newdawn.slick.geom.Circle.new(body.position.x, body.position.y, physics_shape.radius)
                     else
                       raise "DebugTangible does not know how to draw the shape #{physics_shape.class}"
                     end
    graphics.draw(graphics_shape)
  end
end