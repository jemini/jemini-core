class ScoreManager < Gemini::GameObject
  has_behavior :Timeable
  
  def load
    @player1_score = 0
    @player2_score = 0
    @player1_score_text = @game_state.create_game_object :Text, 10, 460, "Score: 0"
    @player2_score_text = @game_state.create_game_object :Text, 580, 460, "Score: 0"
    
    @balls = []
    
    countdown_to_new_round
  end
  
  def countdown_to_new_round
    @countdown_count = 5
    @countdown_text = @game_state.create_game_object :Text, 640 / 2, 480 / 2, "5"
    add_countdown(:new_round_countdown, 5, 1)
    
    listen_for(:timer_tick) do
      @countdown_text.text = (@countdown_text.text.to_i - 1).to_s
    end
    
    listen_for(:countdown_complete) do
      @game_state.remove_game_object @countdown_text
      new_round
    end
  end
  
  def new_round
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
    ball = @game_state.create_game_object_on_layer :Ball, :ball_layer
    ball.move(320, rand(400 - ball.height) + 40)
    add_random_behavior_to_ball ball

    ball.set_force(negative_or_positive_random(7) * 0.02, negative_or_positive_random(4) * 0.02)
#    ball.inertia = [negative_or_positive_random(7), negative_or_positive_random(4)]
    #ball.set_force(negative_or_positive_random(7) * 0.01, 0)
    #ball.set_force(negative_or_positive_random(7) * 10.01, 0)
    #ball.inertia = [0, negative_or_positive_random(7)]
  end
  
  def add_random_behavior_to_ball(ball, recursed = false)
    max = recursed ? 3 : 4
    random = rand(max)
    case random
    when 0
      ball.add_behavior :TriangleTrailEmittable
      #ball.emit_triangle_trail_from_offset(ball.relative_center_vector)
      ball.emit_triangle_trail_with_radius(ball.width / 2)
      ball.layer = :ball_effects_layer
    when 1
      ball.add_behavior :FadingImageTrailEmittable
      ball.emit_fading_image(ball.image)
    when 2
      ball.add_behavior :SplineStretchableSprite
      stretch_spline = Spline.new([0,1.033], [1, 1.066], [2, 1.1], [3, 1.066], [4, 1.033], [5, 1.0], [6, 0.966], [7, 0.933], [8, 0.9], [9, 0.933], [10, 0.966])
      ball.set_stretch_spline stretch_spline
    when 3
      2.times { add_random_behavior_to_ball(ball, true) }
    end
  end
  
  def negative_or_positive_random(max)
    if rand(2) == 0
      rand(max-1) + 1
    else
      -(rand(max-1) + 1)
    end
  end
end