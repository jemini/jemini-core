# deprecated
class Inertial < Jemini::Behavior
  depends_on :UpdatesAtConsistantRate
  
  #A 2-element array with x/y inertial values. 0 means no resistance to acceleration.
  attr_accessor :inertia
  
  def load
    @inertia = [0,0]
    @target.on_update do
      move(@inertia[0] + x, @inertia[1] + y)
    end
  end
end