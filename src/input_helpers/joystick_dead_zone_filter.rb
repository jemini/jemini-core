module JoystickDeadZoneFilter
  def filter_dead_zone(dead_zone, value)
    if dead_zone > value.abs
      0.0
    else
      value
    end
  end
end