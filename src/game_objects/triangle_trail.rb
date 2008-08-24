class Gemini::TriangleTrail < Gemini::GameObject
  has_behavior :Movable2d
  attr_accessor :radius, :alpha
  
  def load
    @trail = []
    @trail_poly_size = 10
    @trail_size = 50
    @radius = 10
    @alpha = 1
    @flip = false
    on_after_move do
      @trail.pop if @trail.size >= @trail_size
      @trail.unshift([x, y])
    end
  end
  
  def draw
    if @trail.size > 3
      gl = Java::org::newdawn::slick::opengl::renderer::Renderer.get

      #Java::org::newdawn::slick::opengl::SlickCallable.new do
      callable_class = Java::org::newdawn::slick::opengl::SlickCallable
      callable_class.enter_safe_block
        # use LWJGL's const directly, Slick's wrapper does not have the triangle strip const
        triangle_strip_enum = Java::org::lwjgl::opengl::GL11::GL_TRIANGLE_STRIP
          gl.gl_begin triangle_strip_enum
          gl.gl_color4f(0.0, 1.0, 1.0, @alpha)

          origin_x, origin_y = calculate_point_on_trail_edge(@trail[1], @trail[0], @radius, @flip)
          gl.gl_vertex2f(origin_x, origin_y)

          flipped_origin_x, flipped_origin_y = calculate_point_on_trail_edge(@trail[1], @trail[0], @radius, !@flip)
          gl.gl_vertex2f(flipped_origin_x, flipped_origin_y)
          
          last_trail_vector = @trail[1]
          #gl.gl_color4f(0.0, 1.0, 1.0, alpha)
          @trail[2..-1].each_with_index do |trail_vector, index|
            next if trail_vector == last_trail_vector
            actual_trail_size = (@trail.size - 1).to_f
            trail_radius = (@radius) * ((actual_trail_size - (index + 2).to_f) / actual_trail_size)
            
            rotated_x, rotated_y = calculate_point_on_trail_edge(trail_vector, last_trail_vector, trail_radius, @flip)
            gl.gl_vertex2f(rotated_x, rotated_y)
            rotated_x, rotated_y = calculate_point_on_trail_edge(trail_vector, last_trail_vector, trail_radius, !@flip)
            gl.gl_vertex2f(rotated_x, rotated_y)
            
            last_trail_vector = trail_vector
          end
          gl.gl_end
      callable_class.leave_safe_block
    end
  end
  
  def calculate_point_on_trail_edge(current_vector, previous_vector, trail_radius, flip)
    trail_diff = [current_vector[0] - previous_vector[0], current_vector[1] - previous_vector[1]]
    diff_angle = Math.atan2(trail_diff[1].to_f, trail_diff[0].to_f)

    rotation_angle = (Math::PI * 1) / 2
    rotation_angle = -rotation_angle if flip
    
    sine = Math.sin(diff_angle + rotation_angle)
    cosine = Math.cos(diff_angle + rotation_angle)
    rotated_weight_x = cosine
    rotated_weight_y = sine
    
    rotated_x = (trail_radius * rotated_weight_x) + current_vector[0]
    rotated_y = (trail_radius * rotated_weight_y) + current_vector[1]
    
    [rotated_x, rotated_y]
  end
  
  def normalize_vector(vector)
    max_value = vector.map{|value| value.abs}.max
    return Array.new(vector.size, 0) if max_value.zero?
    vector.map {|value| value / max_value}
  end
end