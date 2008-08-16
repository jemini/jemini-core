class CollidableWhenMoving < Gemini::Behavior
  depends_on :WorldCollidable
  depends_on :Movable2d

  def load
    @target.on_after_move do
      world_collision_check
    end
  end
end