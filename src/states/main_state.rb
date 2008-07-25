class MainState < Gemini::BaseState
  def load
    @sprites = []
    1.times {@sprites << Duke.new}
  end
  
  def update(delta)
    @sprites.each { |sprite| sprite.update(delta) }
  end
  
  def render(graphics)
    @sprites.each { |sprite| sprite.draw }
  end
end