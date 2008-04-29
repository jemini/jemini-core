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

class GameObject
  @@behaviors = Hash.new{|h,k| h[k] = []}
  def self.has_behavior(behavior)
    @@behaviors[self] << behavior
  end

  private
  def behaviors
    @@behaviors[self.class]
  end
  public
  
  def initialize
    @behaviors = {}
    behaviors.each do |behavior|
      klass = Object.const_get(behavior)
      behavior_instance = klass.new(self)
      behavior_instance.load
      @behaviors[klass.name.to_sym] = behavior_instance
      behavior_instance.dependant_behaviors.each do |dependant_behavior|
        @behaviors[dependant_behavior.class.name.to_sym] = dependant_behavior
      end
    end
  end
  
  def remove_behavior(behavior)
    behavior_instance = @behaviors.delete(behavior)
    behavior_instance.dependant_behaviors.each do |dependant_behavior|
      @behaviors.delete(dependant_behavior.class.name.to_sym)
    end
    behavior_instance.delete
  end
end

#==============

class Position2D < Behavior
  attr_accessor :x, :y
  declared_methods :x, :y, :x=, :y=
  
  def load
    @x = 0
    @y = 0    
  end
end

class Movable2D < Behavior
  depends_on :Position2D
  declared_methods :move
  has_callback :before_move
  has_callback :after_move
  
  def move(x, y)
    # notify :before_move
    self.x = x
    self.y = y
    # notify :after_move
  end
end

class PacMan < GameObject
  has_behavior :Movable2D
#  before_move { check_for_wall_collision }
end

pacman = PacMan.new
p pacman.methods.sort
pacman.move(5,4)
puts pacman.x
puts pacman.y
pacman.remove_behavior :Movable2D
p pacman.methods.sort


# class Fast
#   def foo
#     "The result is: #{((10*354)/25)%17}"
#   end
# end
# 
# class Slow
#   define_method :foo, lambda {"The result is: #{((10*354)/25)%17}"}
# end
# 
# class Between
#   eval <<-ENDL
#     def foo
#       "The result is: \#{((10*354)/25) % 17}"
#     end
# ENDL
# end
# 
# class Lambda
#   @@lambda = lambda {"The result is: #{((10*354)/25)%17}"}
#   def foo
#     @@lambda.call
#   end
# end
# 
# class Lambda2
#   @@lambda = lambda {"The result is: #{((10*354)/25)%17}"}
#   eval <<-ENDL
#   def foo
#     @@lambda.call
#   end
# ENDL
# end
# 
# require 'benchmark'
# 
# Benchmark.bm do |x|
#   f = Fast.new
#   s = Slow.new
#   b = Between.new
#   l = Lambda.new
#   l2 = Lambda2.new
#   100000.times { f.foo }
#   100000.times { b.foo }
#   100000.times { s.foo }
#   100000.times { l.foo }
#   100000.times { l2.foo }
#   
#   x.report {100000.times { f.foo } }
#   x.report {100000.times { b.foo } }
#   x.report {100000.times { s.foo } }
#   x.report {100000.times { l.foo } }
#   x.report {100000.times { l2.foo } }
# end
# 
# # jruby -J-server module_test.rb 
# #       user     system      total        real
# #   0.269000   0.000000   0.269000 (  0.269000)
# #   0.188000   0.000000   0.188000 (  0.188000)
# #   0.147000   0.000000   0.147000 (  0.146000)
# #   0.173000   0.000000   0.173000 (  0.173000)
# #   0.177000   0.000000   0.177000 (  0.177000)