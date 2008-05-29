class Behavior
  attr_accessor :dependant_behaviors
    
  protected
  def self.depends_on(behavior)
    add_dependency(behavior)
  end
  
  def self.has_callback(*args)
    
  end
  
  private
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
  public

  def initialize(target)
    @target = target
    @dependant_behaviors = []
    self.class.dependencies.each do |dependant_behavior|
      dependant_instance = Object.const_get(dependant_behavior).new(@target)
      dependant_instance.load
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
    @dependant_behaviors.each {|dependant| dependant.delete}
    self.class.declared_method_list.each do |method|
      begin
        target_class = class <<@target; self; end
        target_class.send(:remove_method, method)
      rescue NameError
        # just continue if this method isn't there anymore
      end
    end
  end
  
  def method_missing(method, *args, &blk)
    @target.send(method, *args, &blk)
  end
  
  def add; end
  def remove; end
  def load; end
  def unload; end
end