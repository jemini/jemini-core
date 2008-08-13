require 'behavior'

module Gemini
  class GameObject
    attr_accessor :state
    
    @@behaviors = Hash.new{|h,k| h[k] = []}
    def self.has_behavior(behavior)
      require "behaviors/#{behavior.underscore}"
      @@behaviors[self] << behavior
    end

    def initialize(*args)
      @state = BaseState.active_state
      @callbacks = Hash.new {|h,k| h[k] = []}
      @behaviors = {}
      
      behaviors.each do |behavior|
        add_behavior(behavior)
      end
      load(*args)
    end

    def add_behavior(behavior)
      klass = Object.const_get(behavior)
      klass.add_to(self)
    rescue NameError => e
      raise "Unable to load behavior #{behavior}, #{e.message}"
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
    # the method foo, enable_listeners_for would generate the method on_foo and when
    # notify was called with an event name of :foo, all callback blocks registered 
    # with the on_foo method would be called.
    def enable_listeners_for(*methods)
      methods.each do |method|
        code = <<-ENDL
          def on_#{method}(&callback)
            @callbacks[:#{method}] << callback
          end
        ENDL

        self.instance_eval code, __FILE__, __LINE__
      end
    end
    
    def notify(event_name, event = nil, callback_status = nil)
      @callbacks[event_name.to_sym].each do |callback|
        if event
          if callback_status
            callback.call(event, callback_status)
            break unless callback_status.nil? or callback_status.continue?
          else
            callback.call(event)
          end
        else
          callback.call
        end
      end
    end
    
    def kind_of?(klass)
      super || @behaviors.values.inject(false){|result, behavior| result || behavior.class == klass}
    end
    alias_method :is_a?, :kind_of?
    
    def load(*args); end
    
  private
    def behaviors
      @@behaviors[self.class]
    end  
  end
end