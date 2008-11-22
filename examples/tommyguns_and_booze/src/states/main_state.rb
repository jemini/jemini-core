class MainState < Gemini::BaseState 
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    manager(:game_object).add_layer_at(:character, 1)
    
    load_keymap :MainGameKeymap
    
    car = create_game_object_on_layer :Car, :character
    car.set_position(Vector.new(0,0))
    car.image_rotation = 180
    
    set_manager :render, create_game_object(:ScrollingRenderManager, car)
    
#    gangster = create_game_object_on_layer :Gangster, :character
#    gangster.set_position(300,300)
#    gangster.set_rotation_target car

    # Load map image
#    map = create_game_object(:Background, 'large_map.png')
    map1 = create_game_object(:Background, 'map_tile_0_0.png')
    map1.move_by_top_left(0,0)
    map2 = create_game_object(:Background, 'map_tile_1_0.png')
    map2.move_by_top_left(2048,0)
    map3 = create_game_object(:Background, 'map_tile_2_0.png')
    map3.move_by_top_left(4096,0)
    map4 = create_game_object(:Background, 'map_tile_0_1.png')
    map4.move_by_top_left(0,2048)
    map5 = create_game_object(:Background, 'map_tile_1_1.png')
    map5.move_by_top_left(2048,2048)
    map6 = create_game_object(:Background, 'map_tile_2_1.png')
    map6.move_by_top_left(4096,2048)
    map7 = create_game_object(:Background, 'map_tile_0_2.png')
    map7.move_by_top_left(0,4096)
    map8 = create_game_object(:Background, 'map_tile_1_2.png')
    map8.move_by_top_left(2048,4096)
    map9 = create_game_object(:Background, 'map_tile_2_2.png')
    map9.move_by_top_left(4096,4096)
    
    # Load map data
    map_data = File.readlines('data/small_map.txt')
    #map_data = File.readlines('data/test_map.txt')
    #map_data = File.readlines('data/collision_export.txt')
    map_data.reject! {|line| line =~ /^\s*#/ || line.strip.empty?}
    map_tiles = []
    puts "#{map_data.size} buildings to load"
#    map_data.each_with_index do |line, index|
#      puts "Loading building #{index}"
#      parts = line.chomp.split('_')
#      image_name, tangible, rotation, flipping, x, y = parts
#      image_name, tangible, rotation, flipping, x, y = image_name,"true" == tangible, rotation.to_i, flipping, x.to_i, y.to_i
#
#      if tangible
#        tile = create_game_object(:StaticSprite, "#{image_name}.png")
#        tile.rotation = rotation
#        #tile.set_shape :Box, 64, 64
#      else
#        tile = create_game_object :GameObject
#        tile.add_behavior :Sprite
#        tile.image = "#{image_name}.png"
#        tile.image_rotation = rotation
#      end
#      tile.move_by_top_left(x, y)
#      if "horizontal" == flipping
#        tile.flip_horizontally
#      elsif "vertical" == flipping
#        tile.flip_vertically
#      end
#      
#      map_tiles << tile
#    end
    
    region = create_game_object :TangibleObject
#    region.set_shape :Box, 200, 200
#    region.move(500,500)
#    region.set_static_body
#    #region.set_mass 0.0000000001
#    region.set_mass Tangible::INFINITE_MASS
    
    # uncomment to enable profiler (needs keymap too)
#    quitter = create_game_object :GameObject
#    quitter.add_behavior :RecievesEvents
#    quitter.handle_event :quit do
#      Profiler__::print_profile(STDERR) if $profiling
#      Java::java::lang::System.exit 0
#    end
  end
end
