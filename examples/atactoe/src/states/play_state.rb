class PlayState < Gemini::BaseState
  
  attr_accessor :grid
  
  def load(target_score)
    
    @grid = Hash.new{|h,k| h[k] = Hash.new}
    
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
    
    [0, 1].each do |player_id|
      create :Cursor, player_id
    end
    
    manager(:sound).loop_song "j-hop.ogg", :volume => 0.6

    game_end_checker = create :GameObject, :Updates, :ReceivesEvents
    game_end_checker.handle_event :quit do
      switch_state :MenuState, target_score
    end
    game_end_checker.on_update do
      next if @switching_state
      winning_mark = winner
      next unless winning_mark
      @switching_state = true
      end_game_text = create :Text, screen_width / 2, screen_height / 2, "#{winning_mark.to_s.capitalize} wins!"
      end_game_text.add_behavior :Timeable
      end_game_text.add_countdown :end_game, 1
      end_game_text.on_countdown_complete do
        switch_state :MenuState, target_score
      end
    end

    after_warmup = create :GameObject, :Timeable
    after_warmup.add_countdown(:warmup, 1)
    after_warmup.on_countdown_complete do
      #TODO
    end
  end
  
  private
  
    def winner
      puts @grid.inspect
      #Compare columns.
      return @grid[-1][-1] if @grid[-1][-1] == @grid[-1][ 0] and @grid[-1][-1] == @grid[-1][ 1]
      return @grid[ 0][-1] if @grid[ 0][-1] == @grid[ 0][ 0] and @grid[ 0][-1] == @grid[ 0][ 1]
      return @grid[ 1][-1] if @grid[ 1][-1] == @grid[ 1][ 0] and @grid[ 1][-1] == @grid[ 1][ 1]
      #Compare rows.
      return @grid[-1][-1] if @grid[-1][-1] == @grid[ 0][-1] and @grid[-1][-1] == @grid[ 1][-1]
      return @grid[-1][ 0] if @grid[-1][ 0] == @grid[ 0][ 0] and @grid[-1][ 0] == @grid[ 1][ 0]
      return @grid[-1][ 1] if @grid[-1][ 1] == @grid[ 0][ 1] and @grid[-1][ 1] == @grid[ 1][ 1]
      #Compare diagonals.
      return @grid[-1][-1] if @grid[-1][-1] == @grid[ 0][ 0] and @grid[-1][-1] == @grid[ 1][ 1]
      return @grid[-1][ 1] if @grid[-1][ 1] == @grid[ 0][ 0] and @grid[-1][ 1] == @grid[ 1][-1]
      return nil
    end
  
end
