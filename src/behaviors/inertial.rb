#Makes an object resist changes in velocity.
class Inertial < Gemini::Behavior
  depends_on :UpdatesAtConsistantRate
  attr_accessor :inertia
  
  def load
    @inertia = [0,0]
    @target.on_update do
      move(@inertia[0] + x, @inertia[1] + y)
    end
  end
end