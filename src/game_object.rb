require 'behavior'

module Gemini
  class GameObject
    @@behaviors = Hash.new{|h,k| h[k] = []}
    def self.has_behavior(behavior)
      @@behaviors[self] << behavior
    end

    def initialize(*args)
      @callbacks = Hash.new {|h,k| h[k] = []}
      @behaviors = {}
      
      behaviors.each do |behavior|
        add_behavior(behavior)
      end
      load(*args)
    end

    # TODO: Refactor the removal of behaviors from @behavior to live in the
    # behavior class.  This will mirror how behaviors get added to the array
    # in Behavior#add_to
    def remove_behavior(behavior)
      behavior_instance = @behaviors.delete(behavior)
      behavior_instance.dependant_behaviors.each do |dependant_behavior|
        @behaviors.delete(dependant_behavior.class.name.to_sym)
      end
      behavior_instance.delete
    end
    
    # Takes a method and adds a corresponding listener registration method. Given
    # the method foo, add_listener_for would generate the method on_foo and when
    # notify was called with an event name of :foo, all callback blocks registered 
    # with the on_foo method would be called.
    def add_listener_for(method)
      code = <<-ENDL
        def on_#{method}(&callback)
          @callbacks[:#{method}] << callback
        end
      ENDL

      self.instance_eval code, __FILE__, __LINE__
    end
    
    def notify(event_name, event = nil, callback_status = nil)
      @callbacks[event_name.to_sym].each do |callback| 
        callback.call(event || Gemini::BehaviorEvent.new, callback_status)
        break unless callback_status.nil? or callback_status.continue?
      end
    end
    
    def load(*args); end
    
    private
    def behaviors
      @@behaviors[self.class]
    end
    
    def add_behavior(behavior)
      klass = Object.const_get(behavior)
      behavior_instance = klass.add_to(self)
    end
  end
end