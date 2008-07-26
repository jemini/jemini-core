require 'behavior'
require 'game_object'

describe Gemini::Behavior do
  class BehaviorTestGameObject < Gemini::GameObject; end
  
  before :each do
    @game_object = BehaviorTestGameObject.new
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

    behavior = CallsLoad.add_to(@game_object)
    behavior.was_called.should be_true
  end
  
  it "calls unload upon deletion" do
    class CallsUnload < Gemini::Behavior
      attr_reader :was_called
      def unload
	@was_called = true
      end
    end

    behavior = CallsUnload.add_to(@game_object)
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
    
    behavior = DependentLoadBehavior.add_to(@game_object)
    behavior.send(:instance_variable_get, "@dependant_behaviors")[0].was_called.should be_true
    behavior.send(:instance_variable_get, "@dependant_behaviors")[1].was_called.should be_true
  end
  
  it "maintains a reference count of GameObjects that depend on it" do
    class ReferenceCountBehavior < Gemini::Behavior; end
    
    class ParentOfReferenceCountBehavior < Gemini::Behavior
      depends_on :ReferenceCountBehavior
    end
    
    behavior = ReferenceCountBehavior.add_to(@game_object)
    behavior.reference_count.should == 1
    
    parent_behavior = ParentOfReferenceCountBehavior.add_to(@game_object)
    parent_behavior.reference_count.should == 1
    behavior.reference_count.should == 2
    
    ReferenceCountBehavior.remove_from(@game_object)
    behavior.reference_count.should == 1
    
    ParentOfReferenceCountBehavior.remove_from(@game_object)
    parent_behavior.reference_count.should == 0
    behavior.reference_count.should == 0
  end
  
  it "removes its dependant behaviors if not in use by another behavior" do
    class RemovalBehavior < Gemini::Behavior; end
    
    class ParentOfRemovalBehavior < Gemini::Behavior
      depends_on :RemovalBehavior
    end
    
    parent = ParentOfRemovalBehavior.add_to(@game_object)
    removal_behavior = ParentOfRemovalBehavior.send(:class_variable_get, "@@depended_on_by")[@game_object].find {|b| b.class == RemovalBehavior}
    ParentOfRemovalBehavior.remove_from(@game_object)
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
    
    parent = ParentOfShouldNotRemoveBehavior.add_to(@game_object)
    ShouldNotRemoveBehavior.add_to(@game_object)
    
    @game_object.methods.member?('should_exist').should be_true
    @game_object.methods.member?('should_also_exist').should be_true
    @game_object.methods.member?('should_be_removed').should be_true
    @game_object.methods.member?('should_also_be_removed').should be_true
    
    ParentOfShouldNotRemoveBehavior.remove_from(@game_object)

    @game_object.methods.member?('should_exist').should be_true
    @game_object.methods.member?('should_also_exist').should be_true
    @game_object.methods.member?('should_be_removed').should_not be_true
    @game_object.methods.member?('should_also_be_removed').should_not be_true
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

describe Gemini::Behavior, ".wrap_with_callbacks" do
  before :each do
    @game_object = Gemini::GameObject.new
  end

  it "accepts an array of symbols" do
    class ArrayOfSymbolsBehavior < Gemini::Behavior
      wrap_with_callbacks :foo, :bar
    end
  end
  
  it "renames wrapped methods to wrapped_<method>" do
    class RenameWrappedMethodsBehavior < Gemini::Behavior
      wrap_with_callbacks :foo=, :bar=, :baz, :quux
      def foo=; end
      def bar=; end
      def baz; end
      def quux; end
    end
    
    behavior = RenameWrappedMethodsBehavior.add_to(@game_object)
    behavior.methods.member?("wrapped_foo=").should be_true
    behavior.methods.member?("wrapped_bar=").should be_true
    behavior.methods.member?("wrapped_baz").should be_true
    behavior.methods.member?("wrapped_quux").should be_true
  end
  
  it "creates a wrapper method that calls the wrapped method" do
    class ForwardToWrappedMethodBehavior < Gemini::Behavior
      wrap_with_callbacks :foo, :bar, :baz=
      def foo; end
      def bar; end
      def baz=(value); end
    end
    
    behavior = ForwardToWrappedMethodBehavior.add_to(@game_object)
    behavior.should_receive :wrapped_foo
    behavior.should_receive :wrapped_bar
    behavior.should_receive :wrapped_baz=
    behavior.foo
    behavior.bar
    behavior.baz = 5
  end
  
  it "passes a block from the wrapper method through to the wrapped method" do
    class ForwardBlockToWrappedMethodsBehavior < Gemini::Behavior
      wrap_with_callbacks :method_that_takes_a_block
      def method_that_takes_a_block(&block)
	block.call(10)
      end
    end
    
    behavior = ForwardBlockToWrappedMethodsBehavior.add_to(@game_object)
    value_to_be_changed_in_the_block = 0
    behavior.method_that_takes_a_block do |new_value|
      value_to_be_changed_in_the_block = new_value
    end
    
    value_to_be_changed_in_the_block.should == 10
  end
  
  it "adds listener registration methods of the form on_before_<method> and on_after_<method> to target GameObject" do
    class ListenerRegistrationMethodsAddedBehavior < Gemini::Behavior
      wrap_with_callbacks :foo
      wrap_with_callbacks :bar=
      def foo; end
      def bar=(value); end
    end
    
    behavior = ListenerRegistrationMethodsAddedBehavior.add_to(@game_object)
    @game_object.respond_to?(:on_before_foo).should be_true
    @game_object.respond_to?(:on_after_foo).should be_true
    @game_object.respond_to?(:on_before_bar_changes).should be_true
    @game_object.respond_to?(:on_after_bar_changes).should be_true
  end
  
  it "adds a wrapper method that invokes callbacks before and after the wrapped method" do
    class CallbackInvokedByWrapperMethodBehavior < Gemini::Behavior
      wrap_with_callbacks :foo
      declared_methods :foo
      
      def foo; end
    end
    
    before_triggered = false
    after_triggered = false
    
    behavior = CallbackInvokedByWrapperMethodBehavior.add_to(@game_object)
    @game_object.on_before_foo do
      before_triggered = true
    end
    
    @game_object.on_after_foo do
      after_triggered = true
    end
    
    @game_object.foo

    before_triggered.should == true
    after_triggered.should == true
  end
end