#Makes an object receive events when a time period has elapsed.
class UpdatesAtConsistantRate < Gemini::Behavior
  attr_accessor :updates_per_second
  
  def load
    @update_delay = 0
    @time_since_last_update = 0
    @target.enable_listeners_for :update
    self.updates_per_second = 30
  end
  
  def updates_per_second=(count)
    if 0 == count
      @update_delay = 0
    else
      @update_delay = 1000 / count
    end
    @updates_per_second = count
  end
  
  def update(delta_in_milliseconds)
    @time_since_last_update += delta_in_milliseconds
    if @time_since_last_update > @update_delay
      @time_since_last_update -= @update_delay
      notify :update
    end
  end
end