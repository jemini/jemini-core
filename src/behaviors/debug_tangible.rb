#Makes an object draw its collisions on the screen.
class DebugTangible < Jemini::Behavior
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
    tangible_shape = @target.instance_variable_get(:@__behaviors)[:Tangible].instance_variable_get(:@tangible_shape)
    graphics_shape = if tangible_shape.kind_of? TangibleBox
                       Java::org.newdawn.slick.geom.Polygon.new(tangible_shape.get_points(@target.top_left_position, 0).map{|point| [point.x, point.y]}.flatten.to_java(:float))
#                     elsif tangible_shape.kind_of?(Java::net.phys2d.raw.shapes.Polygon)
#                       Java::org.newdawn.slick.geom.Polygon.new(tangible_shape.get_vertices(body.position, body.rotation).map{|point| [point.x, point.y]}.flatten.to_java(:float))
#                     elsif tangible_shape.kind_of? Java::net.phys2d.raw.shapes.Circle
#                       Java::org.newdawn.slick.geom.Circle.new(body.position.x, body.position.y, tangible_shape.radius)
                     else
                       raise "#{self.class} does not know how to draw the shape #{tangible_shape.class}"
                     end
    graphics.draw(graphics_shape)
  end
end