POWER_UP    = 1.0
POWER_DOWN  = -POWER_UP
MOVE_RIGHT  = 1.0
MOVE_LEFT   = -MOVE_RIGHT
ANGLE_RIGHT = 1.0
ANGLE_LEFT  = -ANGLE_RIGHT


Jemini::InputBuilder.declare do |i|
  i.for 'player_1' do
    i.in_order_to :adjust_angle do
      i.hold :a, :value => ANGLE_LEFT
      i.hold :d, :value => ANGLE_RIGHT
    end

    i.in_order_to :adjust_power do
      i.hold :w, :value => POWER_UP
      i.hold :s, :value => POWER_DOWN
    end

    i.in_order_to :move do
      i.hold :q, :value => MOVE_LEFT
      i.hold :e, :value => MOVE_RIGHT
    end

    i.in_order_to :fire_weapon do
      i.hold :space
      i.hold :left_shift
    end
  end
#  i.in_order_to :steer do
##    i.move :xbox_360_left_stick, :using => :x_axis
#    i.move :left_arrow,          :value =>  1.0
#    i.move :right_arrow,         :value => -1.0
#  end
end