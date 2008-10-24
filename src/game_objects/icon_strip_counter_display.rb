class IconStripCounterDisplay < Gemini::GameObject
  has_behavior :Countable
  has_behavior :Spatial
  #has_behavior :CameraAnchoredDrawable
  attr_accessor :icon, :background, :rows, :columns
  
  def load
    @rows = 0
    @columns = nil
    @icons = []
    @old_x = 0
    @old_y = 0
    self.x = 0
    self.y = 0
    on_after_count_changes do
      puts "count changed #{count}"
      icon_count = count < 0 ? 0 : count
      diff = @icons.size - icon_count
      if diff > 0
        1.upto diff do
          last_icon = @icons.pop
          @game_state.remove_game_object last_icon
        end
      elsif diff < 0
        1.upto diff.abs do
          sprite = @game_state.create_game_object :GameObject
          sprite.add_behavior :Sprite
          sprite.add_behavior :CameraAnchoredDrawable
          sprite.image = @icon
          position_sprite(x, y, @icons.size, sprite)
          @icons << sprite
        end
      end
    end
    on_after_move do
      @icons.each_with_index do |sprite, index|
        position_sprite(x, y, index, sprite)
      end
    end
  end
  
  def position_sprite(offset_x, offset_y, sprite_index, sprite)
    row_number = @rows.nil? ? sprite_index : (sprite_index % @rows)
    column_number = @columns.nil? ? sprite_index : (sprite_index % @columns)
    sprite_x = offset_x + (@icon.width * column_number)
    sprite_y = offset_y + (@icon.height * row_number)
    sprite.move(sprite_x, sprite_y)
  end
end