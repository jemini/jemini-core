class ChargedJumper < Gemini::Behavior
  MAX_JUMP_POWER = 75_000.0
  JUMP_CHARGE_FACTOR = 50.0
  
  depends_on :ReceivesEvents
  depends_on :Physical
  depends_on :Timeable
  
  def load
    @jump_charge = 0.0
    @target.handle_event :charge_jump,  :charge_jump
    @target.handle_event :jump,         :jump_tank

    @target.on_update :update_jump_charge
  end

  def update_jump_charge(delta)
    if @charging_jump
      @jump_charge += delta * JUMP_CHARGE_FACTOR unless @jump_charge >= MAX_JUMP_POWER
    end
  end
  
  def charge_jump(message)
    return unless message.player == @target.player_id
    @charging_jump = true
  end

  def jump_tank(message)
    return unless message.player == @target.player_id
#    return if message.value.nil?
    @charging_jump = false
    # TODO: Check to see if tank is touching anything else
    jump_vector = Vector.from_polar_vector(@jump_charge, @target.physical_rotation)
    @target.add_force jump_vector
    @jump_charge = 0.0
  end
end