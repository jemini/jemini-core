class Background < Gemini::GameObject
  has_behavior :BigSprite
  
  def load(file)
    set_image file
    move 0, 0
  end
end

