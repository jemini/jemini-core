class Gemini::TriangleTrail < Gemini::GameObject
  #has_behavior :Drawable
  has_behavior :Spatial2d
  
  def load
    
  end
  
  def draw
    gl = Java::org::newdawn::slick::opengl::renderer::Renderer.get

    #Java::org::newdawn::slick::opengl::SlickCallable.new do
    callable_class = Java::org::newdawn::slick::opengl::SlickCallable
    callable_class.enter_safe_block
      gl.gl_begin gl.class::GL_TRIANGLES
      alpha = 0.5
      gl.gl_color4f(1.0, 0.0, 0.0, alpha)
      gl.gl_vertex2f(x * 1.1, y * 1.1)
      gl.gl_color4f(0.0, 1.0, 0.0, alpha)
      gl.gl_vertex2f( x * 0.9, y * 0.9)
      gl.gl_color4f(0.0, 0.0, 1.0, alpha)
      gl.gl_vertex2f( 320.0, 240.0)

      gl.gl_color4f(1.0, 0.0, 0.0, alpha)
      gl.gl_vertex3f(10.0, 1.0, 0.0)
      gl.gl_color4f(0.0, 1.0, 0.0, alpha)
      gl.gl_vertex3f( 1.0, -10.0, 0.0)
      gl.gl_color4f(1.0, 1.0, 1.0, alpha)
      gl.gl_vertex3f( 0.0, 0.0, 0.0)
      gl.gl_end
      #gl.flush
    callable_class.leave_safe_block
    #end
  end
end