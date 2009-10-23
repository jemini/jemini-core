class TangibleCollisionEvent
  attr_accessor :other_tangible, :delta

  def initialize(other_tangible, delta)
    @other_tangible = other_tangible
    @delta          = delta
  end
end