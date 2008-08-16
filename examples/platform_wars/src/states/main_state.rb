require 'managers/tag_manager'
require 'ai_manager'
require 'duke'

class MainState < Gemini::BaseState 
  def load
    srand(27)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :ai, create_game_object(:AIManager)
    load_keymap :MainGameKeymap
    
    create_game_object :Duke
  end
end