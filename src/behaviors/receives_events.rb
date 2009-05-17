class ReceivesEvents < Gemini::Behavior
  declared_methods :handle_event
  
  def handle_event(type, method_name=nil, &block)
    if !method_name.nil?
      @target.game_state.manager(:message_queue).add_listener(type, self, @target.send(:method, method_name).to_proc)
    elsif block_given?
      @target.game_state.manager(:message_queue).add_listener(type, self, &block)
    else
      raise "Either a method name or a block must be provided"
    end
  end
end