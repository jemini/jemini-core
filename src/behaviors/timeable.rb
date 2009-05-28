class Timeable < Gemini::Behavior
  depends_on :Updates
  declared_methods :notify_each, :add_countdown, :add_countup
  
  def load
    @target.enable_listeners_for :timer_tick, :countdown_complete
    @timers = {}
    @target.on_update do |delta|
      update_timers delta
    end
  end
  
  def add_countdown(name, seconds, notify_frequency = nil)
    @timers[name] = Timer.new(name, Timer::COUNTDOWN, seconds, notify_frequency) {|timer| @target.notify :timer_tick, timer }
  end
  
  def add_countup(name, seconds, notify_frequency = nil)
    @timers[name] = Timer.new(name, Timer::COUNTUP, seconds, notify_frequency) {|timer| @target.notify :timer_tick, timer }
  end
  
private
  def update_timers(delta)
    @timers.each do |name, timer|
      timer.apply_delta delta
      if timer.countdown_complete?
        @target.notify :countdown_complete, name
      end
    end
    # in order to keep from mutating the array while we iterate, handle separately.
    @timers.delete_if {|name, timer| timer.countdown_complete? }
  end
end

class Timer
  COUNTDOWN = :countdown
  COUNTUP = :countup
  def initialize(name, direction, seconds, notify_frequency, &notify_callback)
    @name = name
    @direction = direction
    @milliseconds = seconds * 1000.0
    @notify_frequency = notify_frequency * 1000.0 if notify_frequency
    @notify_callback = notify_callback unless notify_frequency.nil?
    @current_milliseconds = 0
    @milliseconds_since_last_notify = 0
  end
  
  def apply_delta(delta_in_milliseconds)
    return if @countdown_complete
    
    @current_milliseconds += delta_in_milliseconds
    @milliseconds_since_last_notify += delta_in_milliseconds
    
    if @notify_callback && @notify_frequency && (@milliseconds_since_last_notify >= @notify_frequency)
      @notify_callback.call(self)
      @milliseconds_since_last_notify = 0
    end
    @countdown_complete = true if (COUNTDOWN == @direction) && (@current_milliseconds >= @milliseconds)
  end
  
  def reset
    @current_milliseconds = 0
    @countdown_complete = false
  end
  
  def ticks_elapsed
    (@current_milliseconds / (@notify_frequency)).round
  end
  
  def ticks_left
    ((@milliseconds - @current_milliseconds) / (@notify_frequency)).round
  end
  
  def percent_complete
    @current_milliseconds / @milliseconds
  end
  
  def countdown_complete?
    @countdown_complete
  end
end