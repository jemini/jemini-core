class Inertial < Gemini::Behavior
  depends_on :Movable2d
  depends_on :UpdatesAtConsistantRate
  declared_methods :inertia=, :inertia
  attr_accessor :inertia
  
  def load
    @inertia = [0,0]
    @target.on_update do
      move(@inertia[0] + x, @inertia[1] + y)
    end
  end
end