class BasicGameObjectManager < Gemini::GameObject
  
  def load
    @game_objects = []
    enable_listeners_for :before_add_game_object, :after_add_game_object, :before_remove_game_object, :after_remove_game_object
  end
  
  def add_game_object(game_object)
    notify :before_add_game_object, game_object
    @game_objects << game_object
    notify :after_add_game_object, game_object
  end
  
  def remove_game_object(game_object)
    notify :before_remove_game_object, game_object
    @game_objects.delete(game_object)
    notify :after_remove_game_object, game_object
    game_object.unload
  end
  
  def game_objects
    @game_objects
  end
end