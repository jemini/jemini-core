class Inertial < Gemini::Behavior
  depends_on :Movable2D
  depends_on :UpdatesAtConsistantRate
  declared_methods :inertia=, :inertia
  attr_accessor :inertia
  
  def load
    @inertial = [0,0]
    @target.on_tick do
      move(@inertia[0] + x, @inertia[1] + y)
    end
  end
end