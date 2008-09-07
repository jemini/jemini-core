class DebugTangible < Drawable
  declared_methods :draw
  
  def draw(graphics)
    physics_shape = @target.instance_variable_get(:@behaviors)[:Tangible].instance_variable_get(:@body).shape
    graphics_shape = if physics_shape.kind_of? Java::net::phys2d::raw::shapes::Box
                       Java::org.newdawn.slick.geom.Rectangle.new(x, y, physics_shape.size.x, physics_shape.size.y)
                     elsif physics_shape.kind_of? Java::net.phys2d.raw.shapes.Circle
                       Java::org.newdawn.slick.geom.Circle.new(x, y, physics_shape.radius)
                     elsif physics_shape.kind_of? Java::net.phys2d.raw.shapes.Polygon
                       puts "creating a polygon"
#                       Java::org.newdawn.slick.geom.Polygon.new(points.map{|point| [point.x, point.y]}.flatten.to_java(:float))
                     else
                       puts "could not match any type"
                     end
    
    graphics.draw(graphics_shape)
  end
end