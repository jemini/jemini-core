include_class "org.newdawn.slick.TrueTypeFont"
include_class "java.awt.Font"

class ScoreManager < Gemini::GameObject
  def load(state)
    @state = state
    @player1_score = 0
    @player2_score = 0
    @balls = []
    3.times do
      spawn_new_ball
    end
    @font = TrueTypeFont.new(Font.new("Arial", Font::PLAIN, 12), true)
    @state.manager(:render).on_after_render do |graphics|
      @font.draw_string(10,460, "Score: #{@player1_score}")
      @font.draw_string(580,460, "Score: #{@player2_score}")
    end
  end
  
  def ball_scored(ball)
    if ball.x < 320
      @player2_score += 1
    else
      @player1_score += 1
    end
    @state.manager(:game_object).remove_game_object ball
    spawn_new_ball
    puts "Player 1: #{@player1_score} - Player 2: #{@player2_score}"
  end
  
private
  def spawn_new_ball
    puts "spawning new ball"
    ball = Ball.new
    ball.move(320, rand(480 - ball.height))
    ball.inertia = [negative_or_positive_random(7), negative_or_positive_random(4)]
    @state.manager(:game_object).add_game_object ball
  end
  
  def negative_or_positive_random(max)
    if rand(2) == 0
      rand(max-1) + 1
    else
      -(rand(max-1) + 1)
    end
  end
end