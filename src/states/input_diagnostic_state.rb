class InputDiagnosticState < Jemini::GameState
  def load
    @input = manager(:input)
    @raw_input = @input.instance_variable_get(:@raw_input)
    @input.connected_joystick_size.times do |joystick_index|
      width = joystick_width_offset(joystick_index)
      @joystick_height_offset = 40
      text = create :Text, width, @joystick_height_offset , "Controller #{joystick_index}"
      text.x += text.text_width / 2
      map_all_buttons_for_joystick joystick_index
      map_all_axes_for_joystick joystick_index
    end
  end

  def map_all_axes_for_joystick(joystick_id)
    @raw_input.get_axis_count(joystick_id).times do |axis_id|
      @joystick_height_offset += 10
      axis_text = create :Text, joystick_width_offset(joystick_id), @joystick_height_offset, "axis"
      axis_text.add_behavior :Updates
      axis_text.on_update do
        # TODO: Split name and value for easier alignment
        axis_name =  @raw_input.get_axis_name(joystick_id, axis_id)
        axis_value = @raw_input.get_axis_value(joystick_id, axis_id)
        axis_text.text = "#{axis_name}: #{"%+.2f" % axis_value}"
        axis_text.x = joystick_width_offset(joystick_id) + 20 + (axis_text.text_width / 2)
      end
    end
  end

  def joystick_width_offset(joystick_index)
    80 + (joystick_index * 80)
  end

  def map_all_buttons_for_joystick(joystick_id)
    25.times do |button_id|
      begin
        @raw_input.is_button_pressed(button_id, joystick_id)
      rescue java.lang.ArrayIndexOutOfBoundsException
        return # All done if we reached the end
      end

      @joystick_height_offset += 10
      button_text = create :Text, joystick_width_offset(joystick_id), @joystick_height_offset, "button"
      button_text.add_behavior :Updates
      button_text.on_update do
        button_down = @raw_input.is_button_pressed(button_id, joystick_id)
        button_down_text = button_down ? "Down" : "Up"
        button_text.text = "#{button_id}: #{button_down_text}"
        button_text.x = joystick_width_offset(joystick_id) + 20 + (button_text.text_width / 2)
      end
    end
  end
end