class Balance < Jemini::GameObject
  has_behavior :Physical
  has_behavior :Taggable
  
  def load
    set_shape :Circle, 10
    self.mass = 0.5
    self.restitution = 1.0
    exclude_all_physicals
  end
end