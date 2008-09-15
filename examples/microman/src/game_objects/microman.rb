class Microman < Gemini::GameObject
  has_behavior :PlatformerControllable
  
  def load
    set_bounded_image "microman-standing.png"
    set_player_number 1
  end
end