#Makes an object attract other Physical game objects towards it.
class Repulsive < Gemini::Behavior
  depends_on :Physical
  
  #The force to exert.  0 means no push.
  attr_accessor :push
  alias_method :set_push, :push=
  
  #There is no effect on targets that are beyond this distance.
  attr_accessor :effect_radius
  alias_method :set_effect_radius, :effect_radius=

  def load
    @push = 0
    @effect_radius = 0
    @target.on_update do |delta|
      physicals = @target.game_state.manager(:game_object).game_objects.select {|game_object| game_object.kind_of? Physical}.compact
      physicals.each do |physical|
        next if @target == physical
        distance = @target.position.distance_from physical
        next if distance > @effect_radius
        force = delta * @push / (distance * Gemini::Math::SQUARE_ROOT_OF_TWO)
        repulsion = Vector.from_polar_vector(force, physical.position.angle_from(@target))
        physical.add_force repulsion
      end
    end
  end
end
