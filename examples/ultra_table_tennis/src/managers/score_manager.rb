class ScoreManager < Gemini::GameObject
  def load
    @player1_score = 0
    @player2_score = 0
    @player1_score_text = @game_state.create_game_object :Text, 10, 460, "Score: 0"
    @player2_score_text = @game_state.create_game_object :Text, 580, 460, "Score: 0"
    @balls = []
    
    3.times do
      spawn_new_ball
    end
  end
  
  def ball_scored(ball)
    if ball.x < 320
      @player2_score += 1
      @player2_score_text.text = "Score: #{@player2_score}"
    else
      @player1_score += 1
      @player1_score_text.text = "Score: #{@player1_score}"
    end
    @game_state.manager(:game_object).remove_game_object ball
    spawn_new_ball
  end
  
private
  def spawn_new_ball    
    ball = @game_state.create_game_object :Ball
    ball.move(320, rand(480 - ball.height))
    ball.inertia = [negative_or_positive_random(7), negative_or_positive_random(4)]
  end
  
  def negative_or_positive_random(max)
    if rand(2) == 0
      rand(max-1) + 1
    else
      -(rand(max-1) + 1)
    end
  end
end