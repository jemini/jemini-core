#Makes an object draw its interactions with the physics engine on the screen.
class DebugPhysical < Gemini::Behavior

  PhysVector   = Java::net::phys2d::math::Vector2f
  PhysCircle   = Java::net.phys2d.raw.shapes.Circle
  PhysPolygon  = Java::net.phys2d.raw.shapes.Polygon
  PhysLine  = Java::net.phys2d.raw.shapes.Line
  SlickVector  = Java::org::newdawn::slick::geom::Vector2f
  SlickPolygon = Java::org.newdawn.slick.geom.Polygon
  SlickCircle  = Java::org.newdawn.slick.geom.Circle
  SlickLine    = Java::org.newdawn.slick.geom.Line

  include_class 'net.phys2d.raw.shapes.Box'

  def load
    @target.game_state.manager(:render).on_after_render do |graphics|
      draw(graphics)
    end
  end
  
  def unload
    # TODO: Remove listener for after render?
  end

private
  def draw(graphics)
    #TODO: Support joints and composite bodies(?)
    body = @target.instance_variable_get(:@__behaviors)[:Physical].instance_variable_get(:@body)
    physics_shape = body.shape
    graphics_shape = if physics_shape.kind_of? Box
                       SlickPolygon.new(physics_shape.get_points(body.position, body.rotation).map{|point| [point.x, point.y]}.flatten.to_java(:float))
                     elsif physics_shape.kind_of? PhysPolygon
                       SlickPolygon.new(physics_shape.get_vertices(body.position, body.rotation).map{|point| [point.x, point.y]}.flatten.to_java(:float))
                     elsif physics_shape.kind_of? PhysCircle
                       SlickCircle.new(body.position.x, body.position.y, physics_shape.radius)
#                     elsif physics_shape.kind_of? PhysLine
#                       SlickLine.new(body_position.x, )
                     else
                       raise "#{self.class} does not know how to draw the shape #{physics_shape.class}"
                     end
    graphics.draw(graphics_shape)
  end
end