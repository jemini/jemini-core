# Enables game objects to attract other Tangible game objects towards it
class GravitySource < Gemini::Behavior
  depends_on :Tangible
  
  attr_accessor :gravity
  alias_method :set_gravity, :gravity=
  declared_methods :gravity=, :set_gravity, :gravity

  def load
    @gravity = 0
    @target.on_update do |delta|
      tangibles = @target.game_state.manager(:game_object).game_objects.select {|game_object| game_object.kind_of? Tangible}.compact
      tangibles.each do |tangible|
        next if @target == tangible
        distance = @target.position.distance_from tangible
        force = delta * @gravity / (distance * Tangible::SQUARE_ROOT_OF_TWO)
        gravitation = Vector.from_polar_vector(force, @target.position.angle_from(tangible))
        tangible.add_force gravitation
      end
    end
  end
end