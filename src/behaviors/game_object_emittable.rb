#Makes an object create other objects.
class GameObjectEmittable < Jemini::Behavior
  attr_accessor :emitting_game_object_name
  alias_method :set_emitting_game_object_name, :emitting_game_object_name=
  def load
    @game_object.enable_listeners_for :emit_game_object
  end
  
  def emit_game_object(message=nil)
    game_object = @game_object.game_state.create_game_object @emitting_game_object_name
    @game_object.notify :emit_game_object, game_object
  end
end