require 'behavior_system'

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
      @behaviors[klass.name.to_sym] = behavior_instance
      behavior_instance.dependant_behaviors.each do |dependant_behavior|
        @behaviors[dependant_behavior.class.name.to_sym] = dependant_behavior
      end
    end
    load
  end
  
  def remove_behavior(behavior)
    behavior_instance = @behaviors.delete(behavior)
    behavior_instance.dependant_behaviors.each do |dependant_behavior|
      @behaviors.delete(dependant_behavior.class.name.to_sym)
    end
    behavior_instance.delete
  end
end