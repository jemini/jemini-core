class Timeable < Gemini::Behavior
  depends_on :Updates
  declared_methods :notify_each, :add_countdown, :set_countup
  
  def load
    @target.enable_listeners_for :timer_tick, :countdown_complete
    @timers = {}
    on_update do |delta|
      update_timers delta
    end
  end
  
  def add_countdown(name, seconds, notify_frequency = nil)
    @timers[name] = Timer.new(Timer::COUNTDOWN, seconds, notify_frequency) { notify :timer_tick, name }
  end
  
  def add_countup(name, seconds, notify_frequency = nil)
    @timers[name] = Timer.new(Timer::COUNTUP, seconds, notify_frequency) { notify :timer_tick, name }
  end
  
private
  def update_timers(delta)
    @timers.each do |name, timer|
      timer.apply_delta delta
      if timer.countdown_complete?
        notify :countdown_complete, name 
        @timers.delete name
      end
    end
  end
end

class Timer
  COUNTDOWN = :countdown
  COUNTUP = :countup
  def initialize(direction, seconds, notify_frequency, &notify_callback)
    @direction = direction
    @seconds = seconds
    @notify_frequency = notify_frequency
    @notify_callback = notify_callback unless notify_frequency.nil?
    @current_ticks = 0
    @ticks_since_last_notify = 0
  end
  
  def apply_delta(delta_in_milliseconds)
    return if @countdown_complete
    
    @current_ticks += delta_in_milliseconds
    @ticks_since_last_notify += delta_in_milliseconds
    
    if @notify_callback && @notify_frequency && (@ticks_since_last_notify >= @notify_frequency * 1000)
      @notify_callback.call
      @ticks_since_last_notify = 0
    end
    
    @countdown_complete = true if (COUNTDOWN == @direction) && (@current_ticks >= @seconds * 1000)
  end
  
  def reset
    @current_ticks = 0
    @countdown_complete = false
  end
  
  def percent_complete
    @current_ticks / (@seconds * 1000.0)
  end
  
  def countdown_complete?
    @countdown_complete
  end
end