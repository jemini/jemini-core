require 'tag_manager'
require 'sound_manager'
require 'basic_physics_manager'

# this is just the menu
class MenuState < Jemini::GameState
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :sound, create_game_object(:SoundManager)
    
    load_keymap :MouseKeymap
    #load_keymap :DebugTangible
    
    #manager(:game_object).add_layer_at :background, -5
    manager(:game_object).add_layer_at :gui_text, 5
    
    # negative layers don't work yet. Just make sure this is the first sprite instead
    background = create_game_object :GameObject, :Sprite
    background.set_image "menu_background.png"
    background.move_by_top_left 0, 0
    
    vortex = create_game_object :GameObject, :Sprite, :Updates
    vortex.set_image "clockwise_vortex_large.png"
    vortex.move(screen_width / 2.0, screen_height / 2.0)
    # give the vortex a rotation
    vortex.on_update do |delta|
      vortex.image_rotation += (delta * 0.1)
    end
    vortex.color.alpha = 0.5
    
    @food_count = 0
    gravity_source = create_game_object :GameObject, :GravitySource, :TangibleSprite, :Clickable
    gravity_source.set_bounded_image "singularity_button_background.png"
    gravity_source.dimensions = gravity_source.image_size
    gravity_source.gravity = 200.0
    gravity_source.set_shape :Circle, 32
    gravity_source.set_static_body
    gravity_source.move(screen_width / 2.0, screen_height / 2.0)
    gravity_source.on_after_released do
      switch_state :PlayState
    end
    gravity_source.on_collided do |message|
      remove_game_object message.other
      @food_count -= 1
    end
    
    black_hole_feeder = create_game_object :GameObject, :Timeable
    black_hole_feeder.add_countup(:spawn, 0.0, 0.25)
    black_hole_feeder.on_timer_tick do
      next if @food_count > 100
      @food_count +=1
      black_hole_food = create_game_object :GameObject, :TangibleSprite, :AnimatedSprite
      black_hole_food.set_bounded_image "singularity_button_background.png"
      black_hole_food.set_shape :Circle, 8
      black_hole_food.mass = 10
      black_hole_food.sprites(*(1..5).map {|number| "black_hole_food#{number}.png"})
      black_hole_food.animation_mode :ping_pong
      black_hole_food.animation_fps(10)
      #place the food on the edge
      edge_location = case rand(4)
                      when 0
                        Vector.new(rand(screen_width), 0)
                      when 1
                        Vector.new(0, rand(screen_height))
                      when 2
                        Vector.new(rand(screen_width), screen_height)
                      when 3
                        Vector.new(screen_width, rand(screen_height))
                      end
      black_hole_food.move(edge_location)
      angle = black_hole_food.position.angle_from(gravity_source)
      black_hole_food.add_force(Vector.from_polar_vector(200.0, angle + 90.0))
    end
    
    create_game_object_on_layer(:Text, :gui_text, gravity_source.x, gravity_source.y, "Start")
    
    manager(:sound).loop_song :gravitor_menu
  end
end
