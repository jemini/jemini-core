class MainState < Jemini::BaseState
  def load
    switch_state :MenuState
  end
end
