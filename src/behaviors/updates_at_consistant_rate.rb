class UpdatesAtConsistantRate < Gemini::Behavior
  declared_methods :update, :updates_per_second, :updates_per_second=
  attr_accessor :updates_per_second
  
  def load
    @updates_per_second = 30
    @update_delay = 0
    @time_since_last_update = 0
    @target.add_listener_for :tick
  end
  
  def updates_per_second=(count)
    if 0 == count
      @update_delay = 0
    else
      @update_delay = 1000 / count
    end
  end
  
  def update(delta_in_milliseconds)
    @time_since_last_update += delta_in_milliseconds
    if @time_since_last_update > @update_delay
      @time_since_last_update -= @update_delay
      notify :tick
    end
  end
end