#Controls the objects in the game world.
class BasicGameObjectManager < Gemini::GameObject
  attr_reader :layers
  FRONT_LAYER = 'front'
  BACK_LAYER = 'back'
  
  def load
    enable_listeners_for :before_add_game_object, :after_add_game_object, :before_remove_game_object, :after_remove_game_object
    #@layers = Hash.new{|h,k| h[k] = []}
    @layer_order = [:default]
    @layers = {:default => []}
    @game_objects_to_remove = []
    @game_objects_to_add = []
  end
  
  def __process_pending_game_objects
    @game_objects_to_remove.pop.__destroy until @game_objects_to_remove.empty?
    until @game_objects_to_add.empty?
      layer, game_object = @game_objects_to_add.pop 
      @layers[layer] << game_object
    end
  end
  
  #Called when GameState#create is called.
  #Triggers :before_add_game_object, :after_add_game_object callbacks.
  def add_game_object(game_object)
    notify :before_add_game_object, game_object, :default
    @layers[:default] << game_object
    notify :after_add_game_object, game_object, :default
  end
  
  #Called when GameState#remove is called.
  #Triggers :before_remove_game_object, :after_remove_game_object callbacks.
  def remove_game_object(game_object)
    owning_layer = @layers.values.find {|layer| layer.include? game_object}
    return if owning_layer.nil? #NOTE: Not sure if this is the right thing to do, but at least no exception is thrown
    notify :before_remove_game_object, game_object
    owning_layer.delete game_object
    game_object.unload
    notify :after_remove_game_object, game_object
    @game_objects_to_remove.push game_object
    #game_object.unload
  end
  
  #Adds game object to named layer.
  #Triggers :before_add_game_object, :after_add_game_object callbacks.
  #TODO: If layers are desired for the add game object call, then include them in the notify.
  #      This cannot be as an extra param
  def add_game_object_to_layer(game_object, layer_name)
    notify :before_add_game_object, game_object
    @layers[layer_name] << game_object
    #@game_objects_to_add.push [layer_name, game_object]
    notify :after_add_game_object, game_object
  end
  
  #Moves given object from one layer to another.
  def move_game_object_to_layer(game_object, layer_name)
    owning_layer = @layers.values.find {|layer| layer.include? game_object}
    owning_layer.delete game_object
    @layers[layer_name] << game_object
  end

  #Returns Array of all game objects.
  def game_objects
    game_objects = []
    @layers.values.each do |layer|
      layer.each do |game_object|
        game_objects << game_object
      end
    end
    game_objects
  end
  
  #Returns Array of all layers by drawing order.
  def layers_by_order
    @layer_order.map {|layer_name| @layers[layer_name]}.compact
  end
  
  #Add the named layer at the given drawing order position.
  #Position can be a number or one of the constants FRONT_LAYER or BACK_LAYER.
  def add_layer_at(layer_name, location)
    if location.kind_of? Numeric
      @layer_order.delete_at(location) if @layer_order[location].nil?
      @layer_order.insert(location, layer_name)
    else # string/symbol
      case location.to_s
      when FRONT_LAYER
        @layer_order << layer_name
      when BACK_LAYER
        @layer_order.unshift(layer_name)
      end
    end
    @layers[layer_name] = []
  end
end