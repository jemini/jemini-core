require 'managers/tag_manager'
require 'ai_manager'
require 'duke'

class MainState < Gemini::BaseState 
  def load
    srand(27)
    set_manager(:tag, TagManager.new(self))
    set_manager(:ai, AIManager.new(self))
    load_keymap :MainGameKeymap
    
    add_game_object Duke.new
  end
end