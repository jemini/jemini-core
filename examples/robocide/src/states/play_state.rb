class PlayState < Gemini::BaseState
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :sound, create_game_object(:SoundManager)
    set_manager :tangible, create_game_object(:BasicTangibleManager)
    
    manager(:game_object).add_layer_at :gui_text, 5

    load_keymap :PlayKeymap

    @robots = []
    #, :green, :yellow
    [:red, :blue].map {|c| Color.new(c)}.each_with_index do |color, index|
      robot = create_game_object :GameObject, :Sprite, :Tangible
      robot_eye = create_game_object :GameObject, :AnimatedSprite
      robot.set_image "robot-standing.png"
      robot.set_tangible_shape :Box, robot.image_size
      robot_eye.set_sprites "robot-eye1.png", "robot-eye2.png", "robot-eye3.png", "robot-eye4.png"
      robot_eye.animation_mode :ping_pong
      robot_eye.animation_fps 15
      robot_eye.color = color
      
      robot.on_after_move do
        robot_eye.move_by_top_left(robot.top_left_position.x, robot.top_left_position.y)
      end

      robot.on_tangible_collision do
        puts "robot collided!"
      end

      robot.move(100 * (index + 1), 200)
      @robots << robot
    end

    controlled_robot = @robots.first
    controlled_robot.add_behavior :RecievesEvents
    controlled_robot.handle_event :move do |message|
      vector = Vector.new(*case message.value
                          when :up
                            [0, -1]
                          when :down
                            [0, 1]
                          when :left
                            [-1, 0]
                          when :right
                            [1, 0]
                          end
                         )
      vector.x += controlled_robot.x
      vector.y += controlled_robot.y
      controlled_robot.move vector
    end
    puts "set up robots"

    
    # negative layers don't work yet. Just make sure this is the first sprite instead
#    background = create_game_object :GameObject, :Sprite
#    background.set_image "loading_background.png"
#    background.move_by_top_left 0, 0
#    switch_state :MenuState
  end
end