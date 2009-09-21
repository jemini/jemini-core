class MainState < Jemini::GameState
  def load
    switch_state :MenuState
  end
end
