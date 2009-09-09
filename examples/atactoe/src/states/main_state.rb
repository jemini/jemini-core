class MainState < Gemini::GameState
  def load
    switch_state :MenuState
  end
end
