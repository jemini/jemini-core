class PlayState < Gemini::GameState
  def load(player_count)
    set_manager :physics, create(:BasicPhysicsManager)
    set_manager :tag, create(:TagManager)
    set_manager :sound, create(:SoundManager)
    set_manager :tangible, create(:BasicTangibleManager)
    
    manager(:game_object).add_layer_at :gui_text, 5
    manager(:game_object).add_layer_at :logo, 4
    manager(:game_object).add_layer_at :flag, 3
    

    manager(:render).cache_image :tank_body, "tank-body.png"
    manager(:render).cache_image :ground, "ground.png"
    manager(:render).cache_image :tank_barrel, "tank-barrel.png"
    manager(:render).cache_image :power_arrow_head, "power-arrow-head.png"
    manager(:render).cache_image :power_arrow_neck, "power-arrow-neck.png"
    manager(:render).cache_image :shell, "shell.png"
    manager(:render).cache_image :nuke, "nuke.png"
    manager(:render).cache_image :rolling_mine, "rolling-mine.png"
    manager(:render).cache_image :smoke, "smoke.png"
    manager(:render).cache_image :tank_wheel, "tank-wheel.png"
    manager(:render).cache_image :flag_background, "flag_background.png"
    manager(:render).cache_image :gangplank_logo, "gangplank_logo.png"

    manager(:sound).add_sound :fire_cannon, "fire-cannon.wav"
    manager(:sound).add_sound :explosion, "shell-explosion-int.wav"

    load_keymap :PlayKeymap

    manager(:physics).gravity = 35
    
    create :Background, "hazy-horizon.png"
    
    ground = create :Ground
    ground.fill_dimensions(0, screen_height / 2, screen_width, screen_height)
    
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

    [left_wall, right_wall, floor].each {|o| o.add_tag :ground }
#    ceiling = create :GameObject, :Physical, :Taggable
#    ceiling.set_shape :Box, screen_width, 40
#    ceiling.set_static_body
#    ceiling.body_position = Vector.new(screen_width / 2, 20)
    
    manager(:sound).loop_song "mortor-maddness.ogg", :volume => 0.5

    @tanks = []
    ground.spawn_along player_count, Vector.new(0.0, -40.0) do |index|
      tank = create :Tank, index
      tank.player_id = index
      @tanks << tank
      tank.on_before_remove do |unloading_tank|
        @tanks.delete unloading_tank
      end
      tank
    end
    
    game_end_checker = create :GameObject, :Updates, :HandlesEvents
    game_end_checker.handle_event :quit do
      switch_state :MenuState, player_count
    end
    game_end_checker.on_update do
      next if @tanks.size > 1 || @switching_state
      @switching_state = true
      end_game_text = create :Text, "Player #{@tanks.first.player_id + 1} wins!", :position => screen_size.half
      end_game_text.add_behavior :Timeable
      end_game_text.add_countdown :end_game, 5
      end_game_text.on_countdown_complete do
        switch_state :MenuState, player_count
      end
    end

    after_warmup = create :GameObject, :Timeable
    after_warmup.add_countdown(:warmup, 5)
    after_warmup.on_countdown_complete do
#      @tanks.first.body_position = screen_size.half
    end
  end
  
end
