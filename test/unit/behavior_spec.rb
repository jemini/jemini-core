require 'behavior'
require 'game_object'

describe Gemini::Behavior do
  before :each do
    @game_object = Gemini::GameObject.new
  end
  
  it "can declare dependant behaviors" do
    class DeclareDependantBehavior < Gemini::Behavior
      depends_on :dependency
    end
  end
  
  it "calls load upon instantiation" do
    class CallsLoad < Gemini::Behavior
      attr_reader :was_called
      def load
	@was_called = true
      end
    end

    behavior = CallsLoad.add_to(Object.new)
    behavior.was_called.should be_true
  end
  
  it "calls unload upon deletion" do
    class CallsUnload < Gemini::Behavior
      attr_reader :was_called
      def unload
	@was_called = true
      end
    end

    behavior = CallsUnload.add_to(Object.new)
    behavior.send(:delete)
    behavior.was_called.should be_true
  end
  
  it "loads its dependant behaviors when initializing" do
    class Dependency1 < Gemini::Behavior
      attr_reader :was_called
      def load
	@was_called = true
      end
    end
    
    class Dependency2 < Gemini::Behavior
      attr_reader :was_called
      def load
	@was_called = true
      end
    end
    
    class DependentLoadBehavior < Gemini::Behavior
      depends_on :Dependency1
      depends_on :Dependency2
    end
    
    behavior = DependentLoadBehavior.add_to(Object.new)
    behavior.send(:instance_variable_get, "@dependant_behaviors")[0].was_called.should be_true
    behavior.send(:instance_variable_get, "@dependant_behaviors")[1].was_called.should be_true
  end
  
  it "maintains a reference count of GameObjects that depend on it" do
    class ReferenceCountBehavior < Gemini::Behavior; end
    
    class ParentOfReferenceCountBehavior < Gemini::Behavior
      depends_on :ReferenceCountBehavior
    end
    
    object = Object.new
    
    behavior = ReferenceCountBehavior.add_to(object)
    behavior.reference_count.should == 1
    
    parent_behavior = ParentOfReferenceCountBehavior.add_to(object)
    parent_behavior.reference_count.should == 1
    behavior.reference_count.should == 2
    
    ReferenceCountBehavior.remove_from(object)
    behavior.reference_count.should == 1
    
    ParentOfReferenceCountBehavior.remove_from(object)
    parent_behavior.reference_count.should == 0
    behavior.reference_count.should == 0
  end
  
  it "removes its dependant behaviors if not in use by another behavior" do
    class RemovalBehavior < Gemini::Behavior; end
    
    class ParentOfRemovalBehavior < Gemini::Behavior
      depends_on :RemovalBehavior
    end
    
    object = Object.new
    parent = ParentOfRemovalBehavior.add_to(object)
    removal_behavior = ParentOfRemovalBehavior.send(:class_variable_get, "@@depended_on_by")[object].find {|b| b.class == RemovalBehavior}
    ParentOfRemovalBehavior.remove_from(object)
    removal_behavior.reference_count.should == 0
  end
  
  it "does not remove its dependant behaviors if they are in use by another behavior" do
    class ShouldNotRemoveBehavior < Gemini::Behavior
      declared_methods :should_exist, :should_also_exist
    end
    
    class ParentOfShouldNotRemoveBehavior < Gemini::Behavior
      depends_on :ShouldNotRemoveBehavior
      declared_methods :should_be_removed, :should_also_be_removed
    end
    
    object = Object.new
    parent = ParentOfShouldNotRemoveBehavior.add_to(object)
    ShouldNotRemoveBehavior.add_to(object)
    
    object.methods.member?('should_exist').should be_true
    object.methods.member?('should_also_exist').should be_true
    object.methods.member?('should_be_removed').should be_true
    object.methods.member?('should_also_be_removed').should be_true
    
    ParentOfShouldNotRemoveBehavior.remove_from(object)

    object.methods.member?('should_exist').should be_true
    object.methods.member?('should_also_exist').should be_true
    object.methods.member?('should_be_removed').should_not be_true
    object.methods.member?('should_also_be_removed').should_not be_true
  end
  
  it "adds its declared methods into the GameObject it is attached to when added" do
    class AddTestBehavior < Gemini::Behavior
      declared_methods :foo, :bar, :baz
    end
    behavior = AddTestBehavior.add_to(@game_object)
    
    @game_object.methods.member?("foo").should be_true
    @game_object.methods.member?("bar").should be_true
    @game_object.methods.member?("baz").should be_true
  end
  
  it "removes its declared methods from the GameObject it is attached to when removed" do
    class RemoveTestBehavior < Gemini::Behavior
      declared_methods :foo, :bar, :baz
    end
    behavior = RemoveTestBehavior.add_to(@game_object)
    
    behavior.send(:delete)
    @game_object.methods.member?("foo").should_not be_true
    @game_object.methods.member?("bar").should_not be_true
    @game_object.methods.member?("baz").should_not be_true
  end
  
  it "forwards any unhandled method invocations to the GameObject it is attached to" do
    class ForwardTestBehavior < Gemini::Behavior
      declared_methods :foo, :bar, :baz
    end
    behavior = ForwardTestBehavior.add_to(@game_object)
    
    @game_object.should_receive(:test)
    @game_object.should_receive(:underscore_case)
    @game_object.should_receive(:camelCase)
    @game_object.should_receive(:AllCaps)
    
    behavior.test
    behavior.underscore_case
    behavior.camelCase
    behavior.AllCaps
  end
end