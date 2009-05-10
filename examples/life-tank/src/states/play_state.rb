class PlayState < Gemini::BaseState
  def load
    set_manager :physics, create(:BasicPhysicsManager)
    set_manager :tag, create(:TagManager)
    set_manager :sound, create(:SoundManager)
    set_manager :tangible, create(:BasicTangibleManager)
    
    manager(:game_object).add_layer_at :gui_text, 5
    manager(:physics).gravity = 5

    manager(:render).cache_image :tank_body, "tank-body.png"
    manager(:render).cache_image :ground, "ground.png"
    manager(:render).cache_image :tank_barrel, "tank-barrel.png"
    manager(:render).cache_image :power_arrow_head, "power-arrow-head.png"
    manager(:render).cache_image :power_arrow_neck, "power-arrow-neck.png"
    manager(:render).cache_image :shell, "shell.png"

    manager(:sound).add_sound :fire_cannon, "fire-cannon.wav"
    manager(:sound).add_sound :shell_explosion, "shell-explosion-int.wav"

    load_keymap :PlayKeymap

    create :Background, "hazy-horizon.png"
    
    ground = create :Ground
    ground.fill_dimensions(0, screen_height / 2, screen_width, screen_height)

    @tanks = []
    ground.spawn_along 2, Vector.new(0.0, -10.0) do |index|
      tank = create :Tank
      tank.player = index + 1
      @tanks << tank
      tank.on_before_remove do |unloading_tank|
        @tanks.delete unloading_tank
      end
      tank
    end
    
    left_wall = create :GameObject, :Physical, :Taggable
    left_wall.set_shape :Box, 40, screen_height
    left_wall.set_static_body
    left_wall.body_position = Vector.new(-20, screen_height / 2)
    
    right_wall = create :GameObject, :Physical, :Taggable
    right_wall.set_shape :Box, 40, screen_height
    right_wall.set_static_body
    right_wall.body_position = Vector.new(screen_width + 20, screen_height / 2)

    floor = create :GameObject, :Physical, :Taggable
    floor.set_shape :Box, screen_width, 40
    floor.set_static_body
    floor.body_position = Vector.new(screen_width / 2, screen_height + 20)

    game_end_checker = create :GameObject, :Updates
    game_end_checker.on_update do
      next if @tanks.size > 1 || @switching_state
      @switching_state = true
      end_game_text = create :Text, screen_width / 2, screen_height / 2, "Player #{@tanks.first.player} wins!"
      end_game_text.add_behavior :Timeable
      end_game_text.add_countdown :end_game, 5
      end_game_text.on_countdown_complete do
        switch_state :MenuState
      end
    end

    manager(:sound).loop_song "mortor-maddness.ogg", :volume => 0.5
  end
end