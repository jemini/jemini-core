Jemini::InputBuilder.declare do |i|
  i.in_order_to :start do
    i.press '1'
#    i.press :xbox_360_a
  end

  i.in_order_to :increase_player_count do
    i.press :up_arrow
#    i.press :xbox_360_left_bumper
  end

  i.in_order_to :increase_player_count do
    i.press :down_arrow
#    i.press :xbox_360_right_bumper
  end
end