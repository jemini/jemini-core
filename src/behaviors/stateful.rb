
# Makes an object transition between states.
# Notes from Logan:
# I started on this behavior, and realized what I needed was multiple axises of states for my behavior
# that I wanted to use Stateful in. This behavior is simple, and seems like it would be useful for some cases.
# Thus, the behavior remains, but it is not tested or used at the time of this comment.
class Stateful < Gemini::Behavior
  class StateTransferEvent
    attr_accessor :before_state, :after_state
    def initialize(before_state, after_state)
      @before_state = before_state
      @after_state = after_state
    end
  end
  attr_accessor :default_state, :current_state
  wrap_with_callbacks :transfer_state
  
  def load
    @state_transitions = {}
    @target.enable_listeners_for :state_transfer_accepted
    @target.enable_listeners_for :state_transfer_rejected
  end
  
  def transfer_state(state)
    event = StateTransferEvent.new(@current_state, state)
    if @state_transitions[@current_state].include? state
      @current_state = state
      notify :state_transfer_accepted, event
    else
      notify :state_transfer_rejected, event
    end
  end
end