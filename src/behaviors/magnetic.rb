#Makes an object attract other Physical game objects towards it.
class Magnetic < Jemini::Behavior
  depends_on :Physical
  
  #The force to exert.  0 means no push.
  attr_accessor :magnetism
  alias_method :set_magnetism, :magnetism=
  
  #There is no effect on targets that are beyond this distance.
  attr_accessor :magnetism_max_radius
  alias_method :set_magnetism_max_radius, :magnetism_max_radius=

  #The distance where force progression is cut off. Distances closer than this will be treated as if it were the distance provided
  attr_accessor :magnetism_min_radius
  alias_method :set_magnetism_min_radius, :magnetism_min_radius=

  def load
    @magnetism = 1.0
    @magnetism_max_radius = 1000.0
    @magnetism_min_radius =  10.0
    @target.on_update do |delta|
      physicals = @target.game_state.manager(:game_object).game_objects.select {|game_object| game_object.has_behavior? :Physical}
      physicals.each do |physical|
        next if @target == physical
        distance = @target.body_position.distance_from physical
        next if distance > @magnetism_max_radius
        distance = @magnetism_min_radius if distance < @magnetism_min_radius
        force = delta * @magnetism / (distance * Jemini::Math::SQUARE_ROOT_OF_TWO)
        magnetism = Vector.from_polar_vector(force, @target.body_position.angle_from(physical.body_position))
        physical.add_force magnetism
      end
    end
  end
end
