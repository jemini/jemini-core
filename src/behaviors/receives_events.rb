#Enables an object to respond to events.
class ReceivesEvents < Gemini::Behavior

  def load
    @handled_events = []
  end

  #Add a handler for a given event type.  Subsequent events of the given type will be passed to the given block or the given method name.
  def handle_event(type, method_name=nil, &block)
    if !method_name.nil?
      @target.game_state.manager(:message_queue).add_listener(type, self, @target.send(:method, method_name).to_proc)
    elsif block_given?
      @target.game_state.manager(:message_queue).add_listener(type, self, &block)
    else
      raise "Either a method name or a block must be provided"
    end
    @handled_events << type
  end

  #Unregisters all message handlers for this object.
  def unload
    @handled_events.each {|e| @target.game_state.manager(:message_queue).remove_listener(e, self)}
  end
end