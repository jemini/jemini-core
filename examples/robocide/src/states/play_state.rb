class PlayState < Jemini::GameState
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :sound, create_game_object(:SoundManager)
    set_manager :tangible, create_game_object(:BasicTangibleManager)
    
    manager(:game_object).add_layer_at :gui_text, 5

    load_keymap :PlayKeymap

    @robots = []
    [:red, :blue, :green, :yellow].map {|c| Color.new(c)}.each_with_index do |color, index|
      robot = create_game_object :GameObject, :Sprite, :Tangible
      robot_eye = create_game_object :GameObject, :AnimatedSprite
      robot.set_image :robot-standing
      robot.set_tangible_shape :Box, robot.image_size
      robot_eye.set_sprites :robot_eye1, :robot_eye2, :robot_eye3, :robot_eye4
      robot_eye.animation_mode :ping_pong
      robot_eye.animation_fps 15
      robot_eye.color = color
      
      robot.on_after_move do
        robot_eye.move_by_top_left(robot.top_left_position.x, robot.top_left_position.y)
      end

      robot.on_tangible_collision do
        robot.remove_after_move self
        remove_game_object robot_eye
        robot.remove_tangible_collision self
      end

      robot.move(100 * (index + 1), 200)
      @robots << robot
    end

    player = create_game_object :GameObject, :Sprite, :Tangible
    player.set_image :commando_standing
    player.set_tangible_shape :Box, player.image_size
    player.move(150, 300)
    player.add_behavior :ReceivesEvents
    player.handle_event :move do |message|
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
      vector.x += player.x
      vector.y += player.y
      player.move vector
    end
    
    manager(:tangible).on_update do
      @robots.each do |robot|
        robot.move(robot.x + (rand(3) - 1), robot.y + (rand(3) - 1))
      end
    end
    puts "set up robots"

    
    # negative layers don't work yet. Just make sure this is the first sprite instead
#    background = create_game_object :GameObject, :Sprite
#    background.set_image :loading_background
#    background.move_by_top_left 0, 0
#    switch_state :MenuState
  end
end