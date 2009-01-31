# Enables game objects to attract other Physical game objects towards it
class GravitySource < Gemini::Behavior
  depends_on :Physical
  
  attr_accessor :gravity
  alias_method :set_gravity, :gravity=
  declared_methods :gravity=, :set_gravity, :gravity

  def load
    @gravity = 0
    @target.on_update do |delta|
      physicals = @target.game_state.manager(:game_object).game_objects.select {|game_object| game_object.kind_of? Physical}.compact
      physicals.each do |physical|
        next if @target == physical
        distance = @target.position.distance_from physical
        force = delta * @gravity / (distance * Gemini::Math::SQUARE_ROOT_OF_TWO)
        gravitation = Vector.from_polar_vector(force, @target.position.angle_from(physical))
        physical.add_force gravitation
      end
    end
  end
end