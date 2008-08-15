require 'duke'

class AIManager < Gemini::GameObject
  def load(state)
    @state = state
    @dot_net = []
    @python = []
    @lua = []
    @perl = []
    
    10.times do
      enemy = DotNet.new
      enemy.x = 700
      @dot_net << enemy
      @state.manager(:game_object).add_game_object @dot_net.last
    end
    
  end
end