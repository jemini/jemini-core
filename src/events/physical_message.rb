#TODO: Make subclass of Message
class PhysicsMessage
  attr_reader :other, :event

  def initialize(slick_event, other)
    @event = slick_event
    @other = other
  end
end