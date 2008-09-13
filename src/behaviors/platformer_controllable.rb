# Allows control of a TangibleSprite in a platformer environment.
# Respects multiple players
# TODO: Consider moving some of this to a general platformer behavior
#       This behavior will know if it is on the ground
class PlatformerControllable < Gemini::Behavior
  depends_on :ReceivesEvents
  depends_on :MultiAnimatedSprite
  depends_on :TangibleSprite
  depends_on :Timeable
  
  declared_methods :set_player_number, :player_number=, :player_number
  attr_accessor :player_number
  
  def load
    set_mass 100
    set_damping 5
  end
  
  def player_number=(player_number)
    @player_number = player_number
    @target.handle_event :"p#{player_number}_platformer_movement", :platform_move
    @target.handle_event :"p#{player_number}_platformer_jump",     :platform_jump
  end
  alias_method :set_player_number, :player_number=
  
  def platform_move(message)
    case message.value
    #TODO: Up and down for ladders (aka PlatformerClimbables)
    when :left
      @target.add_force(-5, 0)
    when :right
      @target.add_force( 5, 0)
    end
  end
end