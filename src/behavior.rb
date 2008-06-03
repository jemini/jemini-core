module Gemini
  class Behavior
    attr_accessor :dependant_behaviors
    attr_reader :reference_count

    @@depended_on_by = Hash.new{|h,k| h[k] = []}
    def self.add_to(target)
      unless instance = @@depended_on_by[target].find {|behavior| behavior.class == self}
        instance = self.new(target)
        @@depended_on_by[target] << instance  
      end
      instance.add_reference_count
      instance
    end
    
    def self.remove_from(target)
      if instance = @@depended_on_by[target].find {|behavior| behavior.class == self}
        instance.remove_reference_count
        if 0 == instance.reference_count
          @@depended_on_by[target].delete_if {|behavior| behavior.class == self}
          instance.send(:delete)
        end
      end
    end
    
    protected
    def self.depends_on(behavior)
      add_dependency(behavior)
    end

    def self.has_callback(*args)

    end

    private
    
    def self.new(*args)
      super
    end
    
    @@method_list = Hash.new{|h,k| h[k] = []}
    def self.declared_methods(*methods)
      @@method_list[self] = methods
    end
    def self.declared_method_list
      @@method_list[self]
    end

    @@behavior_dependencies = Hash.new{|h,k| h[k] = []}
    def self.add_dependency(behavior)
      @@behavior_dependencies[self] << behavior
    end
    def self.dependencies
      @@behavior_dependencies[self]
    end

    def initialize(target)
      @target = target
      @dependant_behaviors = []
      self.class.dependencies.each do |dependant_behavior|
        begin
          dependant_class = Object.const_get(dependant_behavior)
        rescue NameError => e
          raise "Cannot load dependant behavior '#{dependant_behavior}' in behavior '#{self.class}'"
        end
        dependant_instance = dependant_class.add_to(@target)
        @dependant_behaviors << dependant_instance
      end

      self.class.declared_method_list.each do |method|
        if method.to_s =~ /=/
          code = <<-ENDL
          def #{method}(arg)
            @behaviors[:#{self.class}].#{method}(arg)
          end
          ENDL
        else
          code = <<-ENDL
          def #{method}(*args, &blk)
            @behaviors[:#{self.class}].#{method}(*args, &blk)
          end
          ENDL
        end
        @target.send(:instance_eval, code, __FILE__, __LINE__)
      end
      self.load
    end

    def delete
      unload
      @dependant_behaviors.each {|dependant| dependant.class.remove_from(@target)}
      self.class.declared_method_list.each do |method|
        begin
          target_class = class <<@target; self; end
          target_class.send(:remove_method, method)
        rescue NameError
          # just continue if this method isn't there anymore
        end
      end
    end
    public
    
    def add_reference_count
      @reference_count ||= 0
      @reference_count += 1
    end
    
    def remove_reference_count
      @reference_count -= 1
    end
    
    def method_missing(method, *args, &blk)
      @target.send(method, *args, &blk)
    end

    def load; end
    def unload; end
  end
end