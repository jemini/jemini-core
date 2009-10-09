require 'listenable_mixin'

module Jemini
  class MethodExistsError < Exception; end
  class InvalidWrapWithCallbacksError < Exception; end
  
  class ValueChangedEvent
    attr_accessor :previous_value, :desired_value
    
    def initialize(previous_value, desired_value)
      @previous_value, @desired_value = previous_value, desired_value
    end
  end
  
  class Behavior
    include ListenableMixin
    attr_reader :reference_count, :game_object
    
    def self.method_added(method)
      if !callback_methods_to_wrap.member?(method) || callback_methods_wrapped.member?(method)
        super
        return
      end
      
      callback_methods_wrapped << method
      alias_method :"wrapped_#{method}", method
      arity = instance_method(:"wrapped_#{method}").arity
      if arity.abs > 0
        args = (1..arity.abs).inject([]){|args, i| args << "arg#{i}" }
        args[-1].insert(0,"*") if arity < 0
      end
      if match = /^(.*)=$/.match(method.to_s)
        method_name = match[1]
        code = <<-ENDL
          def #{method}(#{args})
            raise Jemini::InvalidWrapWithCallbacksError.new("Cannot wrap #{method} with callbacks without \\"#{method_name}\\"") unless respond_to?(:#{method_name})
            event = ValueChangedEvent.new(@game_object.#{method_name}, #{args})
            callback_abort = CallbackStatus.new
            @game_object.notify :before_#{method_name}_changes, event
            if callback_abort.continue?
              self.wrapped_#{method} #{args}
              @game_object.notify :after_#{method_name}_changes, event
            end
          end
        ENDL
        wrapped_methods << "before_#{method_name}_changes"
        wrapped_methods << "after_#{method_name}_changes"
      else
        code = <<-ENDL
          def #{method}(#{(args.join(",") + ",") if args} &block)
            callback_abort = CallbackStatus.new
            @game_object.notify :before_#{method}, callback_abort
            if callback_abort.continue?
              self.wrapped_#{method}(#{(args.join(",") + ",") if args} &block)
              @game_object.notify :after_#{method}
            end
          end
        ENDL
        wrapped_methods << "before_#{method}"
        wrapped_methods << "after_#{method}"
      end
      begin
        self.class_eval(code, __FILE__, __LINE__)
      rescue Exception => exception
        STDERR.puts "Failed to evaluate code:", code
        raise
      end
    end
    
  protected

    @@listener_names = Hash.new {|h,k| h[k] = []}
    def self.listen_for(*listener_names)
      @@listener_names[self].concat listener_names
    end

    def self.listener_names
      @@listener_names[self]
    end

    def self.depends_on(behavior)
      require "behaviors/#{behavior.underscore}"
      add_dependency(behavior)
    end

    def self.depends_on_kind_of(behavior)
      add_kind_of_dependency(behavior)
    end
    
    def self.wrap_with_callbacks(*args)
      @@callback_methods_to_wrap[self].concat args
    end
    
    @@callback_methods_to_wrap = Hash.new {|h,k| h[k] = []}
    def self.callback_methods_to_wrap
      @@callback_methods_to_wrap[self]
    end
    
    @@callback_methods_wrapped = Hash.new {|h,k| h[k] = []}
    def self.callback_methods_wrapped
      @@callback_methods_wrapped[self]
    end
    
    @@wrapped_methods = Hash.new {|h,k| h[k] = []}
    def self.wrapped_methods
      @@wrapped_methods[self]
    end
    
  private
    
    def self.new(*args)
      super
    end
    
    def self.declared_method_list
      public_instance_methods - Behavior.public_instance_methods
    end

    @@behavior_dependencies = Hash.new{|h,k| h[k] = []}
    def self.dependencies
      @@behavior_dependencies[self]
    end
    
    def self.add_dependency(behavior)
      @@behavior_dependencies[self] << behavior
    end
    
    @@kind_of_behavior_dependencies = Hash.new{|h,k| h[k] = []}
    def self.kind_of_dependencies
      @@kind_of_behavior_dependencies[self]
    end
    
    def self.add_kind_of_dependency(behavior)
      @@kind_of_behavior_dependencies[self] << behavior
    end
    
    def initialize(game_object)
      @game_object = game_object
      @dependant_behaviors = []
      @reference_count = 0
      
      initialize_dependant_behaviors

      #TODO: Move this to GameObject
      behavior_list = @game_object.send(:instance_variable_get, :@__behaviors)
      return unless behavior_list[self.class.name.to_sym].nil?
      behavior_list[self.class.name.to_sym] = self 

      initialize_declared_methods
      initialize_listeners

      load
    end

    def initialize_declared_methods
      self.class.declared_method_list.each do |method|
        raise MethodExistsError.new("Error while adding the behavior #{self.class}. The method #{method} already exists on game object #{@game_object}.") if @game_object.respond_to? method
        if method.to_s =~ /=/
          code = <<-ENDL
          def #{method}(arg)
            @__behaviors[:#{self.class}].#{method}(arg)
          end
          ENDL
        else
          code = <<-ENDL
          def #{method}(*args, &blk)
            @__behaviors[:#{self.class}].#{method}(*args, &blk)
          end
          ENDL
        end
        @game_object.send(:instance_eval, code, __FILE__, __LINE__)
      end
    end

    def initialize_dependant_behaviors
      self.class.dependencies.each do |dependant_behavior|
        begin
          dependant_behavior_class = Object.const_get(dependant_behavior)
        rescue NameError
          raise "Cannot load dependant behavior '#{dependant_behavior}' in behavior '#{self.class}'"
        end

        unless @game_object.kind_of? dependant_behavior_class
          @game_object.add_behavior dependant_behavior_class.to_s
          @dependant_behaviors << dependant_behavior
        end
      end
    end

    def initialize_listeners
      @game_object.enable_listeners_for *self.class.listener_names
      @game_object.enable_listeners_for *self.class.wrapped_methods
    end

    def delete
      return if @deleted
      unload
      __remove_listeners
      self.class.declared_method_list.each do |method_name|
        target_class = class <<@game_object; self; end
        target_class.send(:remove_method, method_name)
      end
      #TODO: Make sure we don't delete dependent behaviors that still have depending behaviors
      @dependant_behaviors.each do |dependant| 
        @game_object.remove_behavior dependant
      end
      @deleted = true
    end
    
  public
    
    def set_event_aliases(mappings, block)
      if mappings.kind_of? Hash
        mappings.each do |event, event_alias|
          @game_object.handle_event(event_alias) do |message|
            send(event, message)
          end
        end
      else mappings.kind_of? Symbol
        @game_object.handle_event(mappings) do |message|
          message = message.dup
          send(block.call(message), message)
        end
      end
    end
    
    def add_reference_count
      @reference_count += 1
    end
    
    def remove_reference_count
      @reference_count -= 1
    end

    def load; end
    def unload; end
  end
  
  class CallbackStatus
    def continue?
      true
    end
  end
end