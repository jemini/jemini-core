require 'tag_manager'
require 'sound_manager'
require 'basic_physics_manager'
require 'scrolling_render_manager'

class PlayState < Gemini::GameState
  GRAVITY_WELL_MASS = 100
  SINGULARITY_THRESHOLD = GRAVITY_WELL_MASS * 5.0
  
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :sound, create_game_object(:SoundManager)
    
    load_keymap :MouseKeymap
    
    (1..5).each {|number| manager(:render).cache_image "gravity_cloud#{number}".to_sym, "gravity_cloud#{number}.png" }
    manager(:render).cache_image :singularity, "singularity_button_background.png"
    manager(:render).cache_image :vortex, "clockwise_vortex_large.png"
    manager(:sound).add_sound :gobble, "gravity_gobble.wav"
    manager(:sound).add_sound :fire_gravitor, "fire_gravitor_cannon.wav"
    manager(:sound).add_sound :gasp, "singularity_birth.wav"
    
    key_handler = create_game_object :GameObject, :HandlesEvents
    key_handler.handle_event :toggle_pretty_mode do
      puts "toggling pretty mode"
      @pretty_mode = !@pretty_mode
    end
    key_handler.handle_event :exit_to_menu do
      switch_state :MenuState
    end
     # negative layers don't work yet. Just make sure this is the first sprite instead
    background = create_game_object :GameObject, :Sprite
    background.set_image "tiled_background.png"
    background.move_by_top_left 0, 0
    #background.set_image_size Vector.new(16000, 16000)
    
    ship = create_game_object :GameObject, :TangibleSprite
    ship.set_image "ship.png"
    ship.set_shape :Circle, 32
    ship.set_mass 10
#    ship.on_update do |delta|
#      next if @emitting_gravity_at.nil?
#    end
    # center of the background/'level'
    #ship.move background.image_size.x / 2.0, background.image_size.y / 2.0
    ship.move screen_width / 2.0, screen_height / 2.0
    
    cursor = create_game_object :GameObject, :Pointer
    cursor.set_image "reticule.png"
    cursor.handle_event :mouse_button1_pressed do |message|
      manager(:sound).play_sound :fire_gravitor
      @emitting_gravity_at = message.value.location
      gravity_well = create_game_object :GameObject, :AnimatedSprite, :GravitySource, :TangibleSprite, :Timeable
      
      gravity_well.set_bounded_image manager(:render).get_cached_image(:gravity_cloud5)

      gravity_well.set_shape :Circle, 32
      gravity_well.gravity = GRAVITY_WELL_MASS
      gravity_well.set_mass 40
      gravity_well.add_excluded_physical ship
#      images = (1..5).map {|number| manager(:render).get_cached_image("gravity_cloud#{number}".to_sym)}
#      gravity_well.sprites(*images)
#      gravity_well.animation_fps(30)
#      gravity_well.animation_mode :ping_pong
      gravity_well.move message.value.location
      gravity_well.color.alpha = gravity_well.gravity.to_f / SINGULARITY_THRESHOLD
      
      def gravity_well.lock
        @locked = true
      end
      def gravity_well.locked?
        @locked
      end
      def gravity_well.unlock
        @locked = false
      end
#      gravity_well.add_countup(:dissapate, 0.0, 0.25)
#      gravity_well.on_timer_tick do
#        gravity_well.mass -= 1
#        gravity_well.gravity -= 1
#        gravity_well.color.alpha = gravity_well.mass.to_f / SINGULARITY_THRESHOLD
#        if 0 > gravity_well.mass || 0 > gravity_well.gravity
#          remove_game_object gravity_well
#        end
#      end
      gravity_well.on_collided do |message|
        next unless message.other.kind_of? GravitySource
        gravity_well.unlock if message.other.respond_to?(:locked?) && message.other.locked? && gravity_well.locked?
        next if     message.other.nil? || (message.other.respond_to?(:locked?) && message.other.locked?)
        gravity_well.gravity += message.other.gravity
        gravity_well.mass    += message.other.mass
        gravity_well.lock
        
        remove_game_object message.other unless message.other.respond_to?(:locked?) && message.other.locked?
        manager(:sound).play_sound :gobble
      end
      
      gravity_well.on_after_mass_changes do |event|
        growth_factor = (gravity_well.mass.to_f / event.previous_value.to_f)
        gravity_well.image_scaling(growth_factor)
        gravity_well.set_shape :Circle, gravity_well.radius * (growth_factor)
        gravity_well.gravity = gravity_well.mass
        #gravity_well.color.alpha = gravity_well.gravity.to_f / SINGULARITY_THRESHOLD
        next if gravity_well.gravity < SINGULARITY_THRESHOLD
        
        
        
        vortex = create_game_object :GameObject, :Sprite, :Updates
        vortex.set_image manager(:render).get_cached_image(:vortex)

        # oh, now you've done it.
        manager(:sound).play_sound :gasp
        singularity = create_game_object :GameObject, :TangibleSprite, :GravitySource
        singularity.set_image manager(:render).get_cached_image(:singularity)
        singularity.set_shape :Circle, 32
        singularity.gravity = gravity_well.gravity
        singularity.mass = gravity_well.mass
        singularity.move(gravity_well.position)
        singularity.on_collided do |message|
          singularity.mass += message.other.mass
          growth_factor = (singularity.mass.to_f / message.other.mass.to_f)
          #singularity.image_scaling(growth_factor)
          #singularity.set_shape :Circle, singularity.radius * (growth_factor)
          remove_game_object message.other # NOM NOM NOM
        end

        vortex.move(singularity.position)
        singularity.on_before_unload do
          remove_game_object vortex
        end
        # give the vortex a rotation
        vortex.on_update do |delta|
          vortex.image_rotation += (delta * 0.1)
        end
        vortex.on_before_draw do
          vortex.move(singularity.position)
        end
        vortex.color.alpha = 0.5

        remove_game_object gravity_well
      end
    end
#    cursor.handle_event :mouse_button1_released do |message|
#      @emitting_gravity_at = nil
#    end
    
    turret = create_game_object :GameObject, :Sprite, :Updates #, :RotatesToPoint
    turret.set_image "gravity_turret.png"
    #turret.set_rotation_target cursor
    turret.on_before_draw do
      next if ship.nil?
      turret.image_rotation = turret.position.angle_from(cursor) + 180
      turret.move ship.x, ship.y
    end
    ship.on_before_unload do
      puts "removing ship"
      remove_game_object turret
      switch_state :GameOverState
      #ship.remove_before_draw turret
    end
    
    goal = create_game_object :GameObject, :TangibleSprite
    goal.set_bounded_image "goal.png"
    goal.set_static_body
    goal.move screen_width - 128, screen_height - 128
    goal.on_collided do |message|
      if message.other == ship
        switch_state :VictoryState
      end
    end
    
    #TODO: Move by top left is only on Sprite, but we need it here
#    wall = create_game_object :GameObject, :Tangible
#    wall.set_shape :Box, 20, screen_height
#    wall.move(-20, 0)
#    wall.set_static_body
#    wall = create_game_object :GameObject, :Tangible
#    wall.set_shape :Box, screen_width, 20
#    wall.move 0, -20
#    wall.set_static_body
#    wall = create_game_object :GameObject, :Tangible
#    wall.set_shape :Box, 20, screen_height
#    wall.move screen_width, 0
#    wall.set_static_body
#    wall = create_game_object :GameObject, :Tangible
#    wall.set_shape :Box, screen_width, 20
#    wall.move 0, screen_height
#    wall.set_static_body
    
    @food_count = 0
    black_hole_feeder = create_game_object :GameObject, :Timeable
    black_hole_feeder.add_countup(:spawn, 0.0, 0.25)
    black_hole_feeder.on_timer_tick do
      next if @food_count > 100 || !@emitting_gravity_at
      @food_count +=1
      black_hole_food = create_game_object :GameObject, :TangibleSprite, :AnimatedSprite #, :GravitySource
      #black_hole_food.gravity = 400
      black_hole_food.set_bounded_image "singularity_button_background.png"
      food_radius = 8
      black_hole_food.set_shape :Circle, food_radius
      black_hole_food.add_excluded_physical ship
      black_hole_food.mass = 2
      black_hole_food.sprites(*(1..5).map {|number| "black_hole_food#{number}.png"})
      black_hole_food.animation_mode :ping_pong
      black_hole_food.animation_fps(10)
      if @pretty_mode
        #TODO: TriangleTrailEmittable cannot work as a default behavior currently
        black_hole_food.add_behavior :TriangleTrailEmittable
        black_hole_food.emit_triangle_trail_with_radius food_radius 
      end
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
      #angle = black_hole_food.position.angle_from(gravity_source)
      #black_hole_food.add_force(Vector.from_polar_vector(200.0, angle + 90.0))
      black_hole_food.on_collided do |message|
        next unless message.other.kind_of? GravitySource
        message.other.mass += black_hole_food.mass
        #message.other.gravity += black_hole_food.mass
        remove_game_object black_hole_food
        @food_count -= 1
        manager(:sound).play_sound :gobble
      end
    end
    
    [300, 400, 500, 600, 700, 800, 900, 1000].each do |x|
      space_wall = create_game_object :GameObject, :TangibleSprite
      space_wall.set_bounded_image "space_wall.png"
      space_wall.rotate 90
      space_wall.set_static_body
      space_wall.move_by_top_left(x, 500)
    end
    
    (0..10).map{|i| i * 100}.each do |x|
      [-80, screen_height + 40].each do |y|
        space_wall = create_game_object :GameObject, :TangibleSprite
        space_wall.set_bounded_image "space_wall.png"
        space_wall.set_static_body
        space_wall.rotate 90
        space_wall.move_by_top_left(x, y)
      end
    end
    
    (0..7).map{|i| i * 100}.each do |y|
      [-40, screen_width + 40].each do |x|
        space_wall = create_game_object :GameObject, :TangibleSprite
        space_wall.set_bounded_image "space_wall.png"
        space_wall.set_static_body
        space_wall.move_by_top_left(x, y)
      end
    end
    #set_manager :render, create_game_object(:ScrollingRenderManager, ship)
    manager(:sound).loop_song "gravitor_spatial_thinking.ogg"
  end
end