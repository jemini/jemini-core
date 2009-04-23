class Ground < Gemini::GameObject
  has_behavior :Taggable
  has_behavior :Physical

  def load
    set_static_body
  end
  
  def fill_dimensions(width, height)
    points = [Vector.new(width, height), Vector.new(0,height)] # these are the start points
    (width / 20).times do |point_width|
      rand_height = rand(height.to_f * 0.6) + (height.to_f * 0.2)
      points << Vector.new(point_width * 20, rand_height)
    end
    set_shape :Polygon, *points
  end
end