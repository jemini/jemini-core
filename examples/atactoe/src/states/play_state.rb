class PlayState < Gemini::BaseState
  def load(player_count)
    set_manager :sound, create(:SoundManager)

    manager(:game_object).add_layer_at :gui_text, 5
    
    manager(:render).cache_image :x, "x.png"
    manager(:render).cache_image :o, "o.png"
    manager(:render).cache_image :x_cursor, "x-cursor.png"
    manager(:render).cache_image :o_cursor, "o-cursor.png"
    manager(:render).cache_image :x_match, "x-match.png"
    manager(:render).cache_image :o_match, "o-match.png"

    manager(:sound).add_sound :draw, "draw.wav"
    manager(:sound).add_sound :win, "woo-hoo.wav"

    load_keymap :PlayKeymap

    create :Background, "grid.png"
    
    # x = create :GameObject

    # manager(:sound).loop_song "mortor-maddness.ogg", :volume => 0.5

    game_end_checker = create :GameObject, :Updates, :ReceivesEvents
    # game_end_checker.handle_event :quit do
    #   switch_state :MenuState, player_count
    # end
    game_end_checker.on_update do
      # next if @tanks.size > 1 || @switching_state
      @switching_state = true
      end_game_text = create :Text, screen_width / 2, screen_height / 2, "X/O wins!"
      end_game_text.add_behavior :Timeable
      end_game_text.add_countdown :end_game, 5
      end_game_text.on_countdown_complete do
        # switch_state :MenuState, player_count
      end
    end

    after_warmup = create :GameObject, :Timeable
    after_warmup.add_countdown(:warmup, 1)
    after_warmup.on_countdown_complete do
    
    end
  end
  
  def draw_shape(shape, position)
    shape = create(:Image, manager(:render).get_cached_image(shape), Color.new(:black), 1.0)
    shape.set_position position
  end
end
