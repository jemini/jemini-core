require 'behavior'
require 'listenable_mixin'

module Gemini
  class GameObject
    include ListenableMixin
    attr_reader :game_state
    
    @@behaviors = Hash.new{|h,k| h[k] = []}
    def self.has_behavior(behavior)
      require "behaviors/#{behavior.underscore}"
      @@behaviors[self] << behavior
    end

    def initialize(state, *args)
      @game_state = state
      @callbacks = Hash.new {|h,k| h[k] = []}
      @__behaviors = {}
      enable_listeners_for :before_remove, :after_remove
      behaviors.each do |behavior|
        add_behavior(behavior)
      end
      validate_dependant_behaviors
      load(*args)
    end

    def add_behavior(behavior_name)
        require "behaviors/#{behavior_name.underscore}"
        klass = behavior_name.constantize
        @__behaviors[behavior_name] = klass.new(self) if @__behaviors[behavior_name].nil?
        validate_dependant_behaviors
    rescue NameError => e
      raise "Unable to load behavior #{behavior_name}, #{e.message}\n#{e.backtrace.join("\n")}"
    end

    def __destroy
      notify :before_remove, self
      #TODO: Perhaps expose this as a method on Behavior
      #Gemini::Behavior.send(:class_variable_get, :@@depended_on_by).delete self
      __remove_listeners
      @__behaviors.each do |name, behavior|
        #the list is being modified as we go through it, so check before use.
        next if behavior.nil?
        behavior.send(:delete)
      end
      notify :after_remove, self
    end

    def unload; end
    
    # TODO: Refactor the removal of behaviors from @behavior to live in the
    # behavior class.  This will mirror how behaviors get added to the array
    # in Behavior#add_to
    def remove_behavior(behavior)
      @__behaviors.delete(behavior).send(:delete) unless @__behaviors[behavior].nil?
    end
    
    # Takes a method and adds a corresponding listener registration method. Given
    # the method foo, enable_listeners_for would generate the method on_foo and when
    # notify was called with an event name of :foo, all callback blocks registered 
    # with the on_foo method would be called.
    def enable_listeners_for(*methods)
      methods.each do |method|
        code = <<-ENDL
          def on_#{method}(&callback)
            origin = callback.source
            origin.extend Gemini::ListenableMixin unless origin.kind_of? Gemini::ListenableMixin
            origin.__added_listener_for(self, "#{method}", callback)
            @callbacks[:#{method}] << callback
          end

          def remove_#{method}(object, callback=nil)
            if callback.nil?
              @callbacks[:#{method}].delete_if {|callback| callback.source == object }
            else
              @callbacks[:#{method}].delete callback
            end
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
      super || @__behaviors.values.inject(false){|result, behavior| result || behavior.class == klass}
    end
    alias_method :is_a?, :kind_of?
    
    def load(*args)
      args.each do |behavior_name|
        add_behavior behavior_name
      end
    end
    
  private
    def behavior_event_alias(behavior_class, aliases, &block)
      if behavior = @__behaviors[behavior_class]
        behavior.set_event_aliases(aliases, block)
      else
        raise "No behavior #{behavior_class} for game object #{self}"
      end
    end
    
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
end