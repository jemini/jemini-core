class Shape < Gemini::GameObject
  has_behavior :Sprite
  has_behavior :ReceivesEvents

  attr_accessor :player
  
  def load(player_index)
    @player_id = player_index
    set_bounded_image @game_state.manager(:render).get_cached_image(:x)
    
    # @power_arrow_head = @game_state.create :PowerArrowHead

    on_update do |delta|
      # add_force @movement * MOVEMENT_FACTOR * delta, 0.0
      # @movement = 0.0
      # 
      # self.color = @barrel.color = Color.new(1.0, life_percent, life_percent)
    end
    
    handle_event :move,        :move_tank
    
  end

  def unload
    @game_state.remove @power_arrow_head
  end

private

  def move_tank(message)
    return unless message.player == @player_id
    return if message.value.nil?
    @movement = message.value
  end

end
