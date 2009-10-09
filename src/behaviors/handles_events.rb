#Enables an object to respond to events.
class HandlesEvents < Jemini::Behavior

  def load
    @handled_events = []
    @event_types    = []
  end

  #Add a handler for a given event type.  Subsequent events of the given type will be passed to the given block or the given method name.
  def handle_event(event_name, method_name=nil, &block)
    if !method_name.nil?
      @game_object.game_state.manager(:message_queue).add_listener(event_name, self, @game_object.send(:method, method_name).to_proc)
    elsif block_given?
      @game_object.game_state.manager(:message_queue).add_listener(event_name, self, &block)
    else
      raise "Either a method name or a block must be provided"
    end
    @handled_events << event_name
  end

  def handles_events_for(event_type)
    @event_types << event_type
  end

  def handles_events_for?(event_type)
    @event_types.include? event_type
  end

  #Unregisters all message handlers for this object.
  def unload
    @handled_events.each {|e| @game_object.game_state.manager(:message_queue).remove_listener(e, self)}
  end
end
