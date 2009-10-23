require 'behaviors/tangible'
require 'events/tangible_collision_event'

class TangibleManager < Jemini::GameObject
  has_behavior :HandlesEvents
  has_behavior :Updates
  
  def load
    handle_event :toggle_debug_mode, :toggle_debug_mode
    on_update :check_for_collisions
  end

  def check_for_collisions(delta)
    game_state.manager(:game_object).game_objects.each do |game_object|
      next unless game_object.has_behavior? :Tangible
      game_state.manager(:game_object).game_objects.each do |other_game_object|
        next unless other_game_object.has_behavior? :Tangible
        next if game_object == other_game_object
        if game_object.tangibly_collides_with?(other_game_object)
          game_object.notify :tangible_collision, TangibleCollisionEvent.new(other_game_object, delta)
          other_game_object.notify :tangible_collision, TangibleCollisionEvent.new(game_object, delta)
        end
      end
    end
  end

  def toggle_debug_mode(unused_message=nil)
    @debug_mode = !@debug_mode
    @game_state.manager(:game_object).game_objects.each do |game_object|
      game_object.set_tangible_debug_mode(@debug_mode) if game_object.has_behavior? :Tangible
    end
  end

private

end
