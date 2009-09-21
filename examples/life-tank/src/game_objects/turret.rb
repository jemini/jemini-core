class Turret < Jemini::GameObject
  has_behavior :Sprite

  def load
    set_image :tank_barrel
  end
end