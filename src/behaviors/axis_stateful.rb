#Makes an object transition between several states in succession.
class AxisStateful < Gemini::Behavior
  #Indicates that an object has transitioned from one state to another along an axis.
  class AxialStateTransferEvent
    attr_accessor :before_state, :after_state, :axis
    def initialize(axis, before_state, after_state)
      @axis = axis
      @before_state = before_state
      @after_state = after_state
    end
  end

  attr_accessor :default_state_on_axis, :current_state_on_axis
  wrap_with_callbacks :transfer_state_on_axis
  
  def load
    @state_transitions = {}
    @target.enable_listeners_for :axis_state_transfer_accepted
    @target.enable_listeners_for :axis_state_transfer_rejected
  end
  
  def set_state_transisions_on_axis(axis, transitions)
    @state_transitisions[axis] = transitions
  end
  
  def transfer_state_on_axis(axis, state)
    event = AxialStateTransferEvent.new(axis, @current_state[axis], state)
    if @state_transitions[axis][@current_state[axis]].include? state
      @current_state = state
      notify :axis_state_transfer_accepted, event
    else
      notify :axis_state_transfer_rejected, event
    end
  end
end