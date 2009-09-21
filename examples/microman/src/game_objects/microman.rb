class Microman < Jemini::GameObject
  has_behavior :PlatformerControllable
  has_behavior :GameObjectEmittable
  has_behavior :Audible
  attr_accessor :ammo
  
  def load
    @ammo = 25
    set_bounded_image :microman-standing
    add_animation :name => :stand, :speed => 500, :sprites => [:microman_standing]
    add_animation :name => :jump, :speed => 500, :sprites => [:microman_jumping]
    add_animation :name => :walk,
                  :speed => 200,
                  :sprites => [:microman_walking0,
                               :microman_walking1,
                               :microman_walking2,
                               :microman_walking1]
    add_animation :name => :walk_shoot,
                  :speed => 200,
                  :sprites => [:microman_walking_shooting0,
                               :microman_walking_shooting1,
                               :microman_walking_shooting2,
                               :microman_walking_shooting1]
    # TODO: Looks like we need a post load for behaviors
    animate :stand
    
    load_sound :pew, 'pew.wav'
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
