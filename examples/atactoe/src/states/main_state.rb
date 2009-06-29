class MainState < Gemini::BaseState
  def load
    switch_state :MenuState
  end
end
