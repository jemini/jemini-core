class Microman < Gemini::GameObject
  has_behavior :PlatformerControllable
  has_behavior :GameObjectEmittable
  def load
    set_bounded_image "microman-standing.png"
    set_player_number 1
    add_animation :name => :stand, :speed => 500, :sprites => ["data/microman-standing.png"]
    add_animation :name => :jump, :speed => 500, :sprites => ["data/microman-jumping.png"]
    add_animation :name => :walk,
                  :speed => 200,
                  :sprites => ["data/microman-walking0.png",
                               "data/microman-walking1.png",
                               "data/microman-walking2.png",
                               "data/microman-walking1.png"]
    # TODO: Looks like we need a post load for behaviors
    animate :stand
    
    set_emitting_game_object_name :Bullet
    on_emit_game_object do |bullet|
      puts "emitting bullet #{facing_direction}"
      emit_x = if :east == facing_direction
                 x + (image_size.x / 2) + bullet.image_size.x
               else
                 x - (image_size.x / 2) - bullet.image_size.x
               end
      emit_y = y #+ (image_size.y / 2)
      bullet.move(emit_x, emit_y)
      if :east == facing_direction
        bullet.add_velocity(20, 0)
      else
        bullet.add_velocity(-20, 0)
      end
    end
    handle_event :shoot, :emit_game_object
  end
end