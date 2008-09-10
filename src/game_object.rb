require 'behavior'

module Gemini
  class GameObject
    attr_reader :game_state
    
    @@behaviors = Hash.new{|h,k| h[k] = []}
    def self.has_behavior(behavior)
      require "behaviors/#{behavior.underscore}"
      @@behaviors[self] << behavior
    end

    def initialize(state, *args)
      @game_state = state
      @callbacks = Hash.new {|h,k| h[k] = []}
      @behaviors = {}
      
      behaviors.each do |behavior|
        add_behavior(behavior)
      end
      
      validate_dependant_behaviors
      load(*args)
    end

    def add_behavior(behavior_name)
      require "behaviors/#{behavior_name.underscore}"
      klass = Object.const_get(behavior_name)
#      unless @behaviors.values.find {|behavior| behavior.kind_of? klass}
        klass.add_to(self) 
        validate_dependant_behaviors
 #     end
    rescue NameError => e
      raise "Unable to load behavior #{behavior_name}, #{e.message}\n#{e.backtrace.join("\n")}"
    rescue
      klass.remove_from(self)
      raise
    end
    
    def unload
      #TODO: Perhaps expose this as a method on Behavior
      Gemini::Behavior.send(:class_variable_get, :@@depended_on_by).delete self
      #@behaviors.each {|name, behavior| behavior.class.remove_from self}
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

          def remove_#{method}(object)
            @callbacks[:#{method}].delete {|callback| callback.origin == object }
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
    
    def listen_for(message, target=self, &block)
      target.send("on_#{message}", &block)
    end
    
    def kind_of?(klass)
      super || @behaviors.values.inject(false){|result, behavior| result || behavior.class == klass}
    end
    alias_method :is_a?, :kind_of?
    
    def load(*args); end
    
  private
  
    def validate_dependant_behaviors
      behaviors.each do |behavior|
        behavior.constantize.kind_of_dependencies.each do |dependant_behavior|
          dependency = dependant_behavior.constantize
          #TODO: This code cannot work until the game object has a list of behavior objects (behaviors returns names)
          #next if behaviors.find {|behavior| p behavior; behavior.last.kind_of?(dependency)}
          next
          raise "Dependant behavior '#{dependant_behavior}' was not found on class #{self.class}" 
        end
      end
    end
    
    def behaviors
      @@behaviors[self.class]
    end  
  end
  
#  class Callback
#    attr_reader :origin
#    
#    def initialize(origin, block)
#      @origin = origin
#      @block = block
#    end
#    
#    def notify(event, status = nil)
#      if status.nil?
#        @block.call(event)
#      else
#        @block.call(event, status)
#      end
#    end
#  end
end