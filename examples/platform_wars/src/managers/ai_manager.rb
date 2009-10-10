require 'duke'

class AIManager < Jemini::GameObject
  def load
    @enemies = []
    
    @waves = [:dot_net]#, :python, :perl, :lua].sort!{|a,b| rand(2)-1}
    @current_wave = @waves.shift
    @action = :waiting
    
    game_state.manager(:update).on_before_update do |delta|
      case @action
      when :waiting
        # Spawn a new wave
        case @current_wave
        when :dot_net
          10.times do
            @enemies << game_state.create_game_object(:DotNet)
            @enemies.last.x = 700
          end
        end
        @action = :attacking
      when :attacking
        
      end
    end
  end
end