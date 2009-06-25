class MatchWonState < Gemini::BaseState
  
  def load(target_score, winner)
    set_manager :sound, create(:SoundManager)
    manager(:sound).add_sound :win, "woo-hoo.wav"
    manager(:sound).play_sound :win
    end_match_text = create :Text, screen_width / 2, screen_height / 2, "#{winner.to_s.capitalize} wins the match!"
    end_match_text.add_behavior :Timeable
    end_match_text.add_countdown :end_match, 3
    end_match_text.on_countdown_complete do
      switch_state :MenuState, target_score
    end
  end
    
end