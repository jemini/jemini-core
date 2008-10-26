class Microman < Gemini::GameObject
  has_behavior :PlatformerControllable
  has_behavior :GameObjectEmittable
  has_behavior :Audible
  attr_accessor :ammo
  
  def load
    @ammo = 25
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
    add_animation :name => :walk_shoot,
                  :speed => 200,
                  :sprites => ["data/microman-walking-shooting0.png",
                               "data/microman-walking-shooting1.png",
                               "data/microman-walking-shooting2.png",
                               "data/microman-walking-shooting1.png"]
    # TODO: Looks like we need a post load for behaviors
    animate :stand
    
    load_sound :pew, 'data/pew.wav'
    behavior_event_alias(:PlatformerControllable, 
                         :start_move => :p1_start_platformer_movement, 
                         :stop_move => :p1_stop_platformer_movement, 
                         :jump => :p1_platformer_jump)
    
    set_emitting_game_object_name :Bullet
    on_emit_game_object do |bullet|
      puts "emitting bullet #{facing_direction}"
      emit_x = if :east == facing_direction
                 x + (image_size.x / 2) + bullet.image_size.x
               else
                 x - (image_size.x / 2) - bullet.image_size.x
               end
      emit_y = y #+ (image_size.y / 2)
      emit_sound(:pew)
      bullet.move(emit_x, emit_y)
      if :east == facing_direction
        bullet.add_velocity(20, 0)
      else
        bullet.add_velocity(-20, 0)
      end
    end
    handle_event :shoot, :shoot
  end
  
  def shoot(message)
    emit_game_object if @ammo > 0
    @ammo -= 1
  end
end
