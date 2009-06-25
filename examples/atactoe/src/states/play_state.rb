class PlayState < Gemini::BaseState
  
  attr_accessor :grid
  attr_accessor :score_x
  attr_accessor :score_o

  def load(target_score, score_x, score_o)
    @target_score = target_score
    @score_x = score_x
    @score_o = score_o
    
    set_manager :sound, create(:SoundManager)
    
    manager(:game_object).add_layer_at :gui_text, 5
    
    manager(:render).cache_image :x, "x.png"
    manager(:render).cache_image :o, "o.png"
    manager(:render).cache_image :x_cursor, "x-cursor.png"
    manager(:render).cache_image :o_cursor, "o-cursor.png"
    manager(:render).cache_image :x_match, "x-match.png"
    manager(:render).cache_image :o_match, "o-match.png"

    manager(:sound).add_sound :draw, "draw.wav"
    manager(:sound).add_sound :no, "no.wav"

    load_keymap :PlayKeymap

    create :Background, "grid.png"
    
    # manager(:sound).loop_song "j-hop.ogg", :volume => 0.6
    
    game_end_checker = create :GameObject, :Updates, :ReceivesEvents
    game_end_checker.handle_event :quit do
      switch_state :MenuState, target_score
    end
    game_end_checker.on_update do
      next if @switching_state
      winning_mark = winner
      next unless winning_mark
      @switching_state = true
      increment_score(winning_mark)
      switch_state :GameWonState, @target_score, @score_x, @score_o, winning_mark
    end

    after_warmup = create :GameObject, :Timeable
    after_warmup.add_countdown(:warmup, 1)
    after_warmup.on_countdown_complete do
      #TODO
    end

    [0, 1].each do |player_id|
      create :Cursor, player_id
    end
    
    @score_text_x = create(:Text,
      screen_width * 0.1,
      screen_height * 0.1, 
      "X: #{@score_x}"
    )
    @score_text_o = create(:Text,
      screen_width * 0.9,
      screen_height * 0.1, 
      "O: #{@score_o}"
    )
    
    @grid = Hash.new{|h,k| h[k] = Hash.new}
    
  end
  
  private
  
    def winner
      [
        #Compare columns.
        [@grid[-1][-1], @grid[-1][ 0], @grid[-1][ 1]],
        [@grid[ 0][-1], @grid[ 0][ 0], @grid[ 0][ 1]],
        [@grid[ 1][-1], @grid[ 1][ 0], @grid[ 1][ 1]],
        #Compare rows.
        [@grid[-1][-1], @grid[ 0][-1], @grid[ 1][-1]],
        [@grid[-1][ 0], @grid[ 0][ 0], @grid[ 1][ 0]],
        [@grid[-1][ 1], @grid[ 0][ 1], @grid[ 1][ 1]],
        #Compare diagonals.
        [@grid[-1][-1], @grid[ 0][ 0], @grid[ 1][ 1]],
        [@grid[-1][ 1], @grid[ 0][ 0], @grid[ 1][-1]],
      ].each do |squares|
        return squares[0] if squares[0] and squares[0] == squares[1] and squares[1] == squares[2]
      end
      return nil
    end

    def increment_score(winning_mark)
      case winning_mark
      when :x
        @score_x += 1
        @score_text_x.text = "X: #{@score_x}"
      when :o
        @score_o += 1
        @score_text_o.text = "o: #{@score_o}"
      end
    end
    
    def display_match_winner(winner)
      end_match_text.on_countdown_complete do
        switch_state :MenuState, @target_score
      end
    end
    
end
