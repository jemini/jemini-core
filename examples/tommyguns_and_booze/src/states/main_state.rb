require 'tag_manager'
require 'basic_physics_manager'

class MainState < Gemini::BaseState
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    manager(:game_object).add_layer_at(:character, 1)
    
    load_keymap :MainGameKeymap
    
    car = create_game_object_on_layer :Car, :character
    car.set_position(400,400)
    car.image_rotation = 180
    
    set_manager :render, create_game_object(:ScrollingRenderManager, car)
    
    
    
#    gangster = create_game_object_on_layer :Gangster, :character
#    gangster.set_position(300,300)
#    gangster.set_rotation_target car

    # Load map image
#    map = create_game_object(:Background, 'large_map.png')
    map1 = create_game_object(:Background, 'map_tile_0_0.png')
    map1.move(0,0)
    map2 = create_game_object(:Background, 'map_tile_1_0.png')
    map2.move(2048,0)
    map3 = create_game_object(:Background, 'map_tile_2_0.png')
    map3.move(4096-640,0)
    map4 = create_game_object(:Background, 'map_tile_0_1.png')
    map4.move(0,2048)
    map5 = create_game_object(:Background, 'map_tile_1_1.png')
    map5.move(2048,2048)
    map6 = create_game_object(:Background, 'map_tile_2_1.png')
    map6.move(4096-640,2048)
    map7 = create_game_object(:Background, 'map_tile_0_2.png')
    map7.move(0,4096-64)
    map8 = create_game_object(:Background, 'map_tile_1_2.png')
    map8.move(2048,4096-64)
    map9 = create_game_object(:Background, 'map_tile_2_2.png')
    map9.move(4096-640,4096-64)
    
    # Load map data
    map_data = File.readlines('data/small_map.txt')
    map_data.reject! {|line| line =~ /^\s*#/ || line.strip.empty?}
    puts "#{map_data.size} tiles to load"
    map_tiles = []
    
    map_data.each_with_index do |line, index|
      puts "Loading tile #{index}"
      next if line =~ /^layer/ #skip for now
      parts = line.chomp.split('_')
      name, tangible, rotation, flipping, x, y = parts
      rotation, x, y = rotation.to_i, x.to_i, y.to_i
      tangible = "true" == tangible ? true : false
#      puts "name: #{name}, tangible: #{tangible}, rotation: #{rotation}, flipping: #{flipping}, x: #{x}, y: #{y}"
      if tangible
#        create_game_object(:StaticSprite, "transparent.png", x+32, y+32, 64, 64)
#        tile.rotation = rotation
#        puts "creating tile at #{x+32}, #{y+32}"
#        tile = create_game_object(:GameObject)
#        tile.add_behavior :Tangible
#        
#        tile.set_shape :Box, 64, 64
#        tile.set_mass Tangible::INFINITE_MASS
#        tile.move(x+32, y+32)
#        tile.set_static_body
#        tile.set_restitution 1.0
#        tile.set_friction 0.0
#      else
#        tile = create_game_object :GameObject
#        tile.add_behavior :Sprite
#        tile.image = "#{name}.png"
#        tile.move(x+32, y+32)
#        tile.image_rotation = rotation
      end
      
#      if "horizontal" == flipping
#        tile.flip_horizontally
#      elsif "vertical" == flipping
#        tile.flip_vertically
#      end
      
#      map_tiles << tile
    end
    
    # uncomment to enable profiler (needs keymap too)
#    quitter = create_game_object :GameObject
#    quitter.add_behavior :RecievesEvents
#    quitter.handle_event :quit do
#      Profiler__::print_profile(STDERR) if $profiling
#      Java::java::lang::System.exit 0
#    end
  end
end