class DebugTangible < Drawable
  #declared_methods :draw
  PhysVector = Java::net::phys2d::math::Vector2f
  SlickVector = Java::org::newdawn::slick::geom::Vector2f
  
  def load
    @target.game_state.manager(:render).on_after_render do |graphics|
      draw(graphics)
    end
  end
  
  def draw(graphics)
    body = @target.instance_variable_get(:@behaviors)[:Tangible].instance_variable_get(:@body)
    physics_shape = body.shape
    graphics_shape = if physics_shape.kind_of? Java::net::phys2d::raw::shapes::Box
                       #Java::org.newdawn.slick.geom.Rectangle.new(body.position.x, body.position.y, physics_shape.size.x, physics_shape.size.y)
                       Java::org.newdawn.slick.geom.Polygon.new(physics_shape.get_points(body.position, body.rotation).map{|point| [point.x, point.y]}.flatten.to_java(:float))
                     elsif physics_shape.kind_of? Java::net.phys2d.raw.shapes.Circle
                       Java::org.newdawn.slick.geom.Circle.new(body.position.x, body.position.y, physics_shape.radius)
                     elsif physics_shape.kind_of? Java::net.phys2d.raw.shapes.Polygon
                       puts "creating a polygon"
#                       Java::org.newdawn.slick.geom.Polygon.new(points.map{|point| [point.x, point.y]}.flatten.to_java(:float))
                     else
                       puts "could not match any type"
                     end
    #TODO: Get the points of rotation and draw it                 
    #graphics_shape = graphics_shape.transform Java::org::newdawn::slick::geom::Transform.create_rotate_transform(body.rotation * Tangible::RADIANS_TO_DEGREES_MULTIPLIER, body)

    graphics.draw(graphics_shape)
  end
end