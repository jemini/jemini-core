class ReceivesEvents < Gemini::Behavior
  declared_methods :handle_event

  def load
    @handled_events = []
  end

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

  def unload
    @handled_events.each {|e| @target.game_state.manager(:message_queue).remove_listener(e, self)}
  end
end