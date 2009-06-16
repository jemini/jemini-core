# This behavior rotates to face the tracking point or game object
class RotatesToPoint < Gemini::Behavior
  #TODO: Add offset rotation
  depends_on :Physical
  attr_accessor :rotation_target
  alias_method :set_rotation_target, :rotation_target=
  
  def load
    @target.on_update do
      @target.set_rotation rotation_to_face_target if @rotation_target
    end
  end
  
  def rotation_to_face_target
    #TODO: Use vector
    diff_angle = Gemini::Math.radians_to_degrees Math.atan2(@target.y - @rotation_target.y, @target.x - @rotation_target.x)
  end
end