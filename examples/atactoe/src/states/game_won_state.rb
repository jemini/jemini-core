class GameWonState < Gemini::BaseState
  
  def load(target_score, score_x, score_o, winner)
    set_manager :sound, create(:SoundManager)
    manager(:sound).add_sound :win, "woo-hoo.wav"
    manager(:sound).play_sound :win
    end_game_text = create :Text, screen_width / 2, screen_height / 2, "#{winner.to_s.capitalize} wins!"
    end_game_text.add_behavior :Timeable
    end_game_text.add_countdown :end_game, 0.1
    end_game_text.on_countdown_complete do
      if score_x < target_score and score_o < target_score
        switch_state :PlayState, target_score, score_x, score_o
      else
        switch_state :MatchWonState, target_score, winner
      end
    end
  end
    
end