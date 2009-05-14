require 'spec_helper'
require 'behavior'

describe Gemini::Behavior do
  it_should_behave_like "initial mock state"

  before :each do
    @game_object = Gemini::GameObject.new(@state)
  end
  
  it "can declare dependant behaviors" do
    class DeclareDependantBehavior < Gemini::Behavior
      def self.require(not_used); end
      depends_on :dependency
    end
  end
  
  it "can declare kind_of dependant behaviors" do
    class DeclareKindOfDependantBehavior < Gemini::Behavior
      depends_on_kind_of :dependency
    end
  end
  
  it "calls load upon instantiation" do
    class CallsLoad < Gemini::Behavior
      declared_methods :has_called_load?
      def has_called_load?
        @has_called_load
      end
      
      def load
        @has_called_load = true
      end
    end

    @game_object.add_behavior :CallsLoad
    @game_object.should have_called_load
  end
  
  it "calls unload upon deletion" do
    class CallsUnload < Gemini::Behavior
      declared_methods :calls_unload_behavior

      def calls_unload_behavior
        self
      end
    end

    @game_object.add_behavior :CallsUnload
    @game_object.calls_unload_behavior.should_receive :unload
    @game_object.remove_behavior :CallsUnload
  end
  
  it "loads its dependant behaviors when initializing" do
    class Dependency1 < Gemini::Behavior
      declared_methods :has_loaded_dep1?
      def has_loaded_dep1?
        @was_called
      end
      def load
        @was_called = true
      end
    end
    
    class Dependency2 < Gemini::Behavior
      declared_methods :has_loaded_dep2?
      def has_loaded_dep2?
        @was_called
      end
      def load
        @was_called = true
      end
    end
    
    class DependentLoadBehavior < Gemini::Behavior
      def self.require(not_used); end
      depends_on :Dependency1
      depends_on :Dependency2
    end
    
    @game_object.add_behavior :DependentLoadBehavior
    @game_object.should have_loaded_dep1
    @game_object.should have_loaded_dep2
  end
  
  it "removes its dependant behaviors if not in use by another behavior" do
    class RemovalBehavior < Gemini::Behavior; end
    
    class ParentOfRemovalBehavior < Gemini::Behavior
      def self.require(not_used); end
      depends_on :RemovalBehavior
    end

    @game_object.add_behavior :ParentOfRemovalBehavior
    @game_object.remove_behavior :ParentOfRemovalBehavior
    @game_object.should_not have_behavior(:RemovalBehavior)
  end
  
  it "doesn't remove dependent behaviors when it is removed" do
    class ShouldNotRemoveBehavior < Gemini::Behavior
      declared_methods :should_exist, :should_also_exist
    end
    
    class ParentOfShouldNotRemoveBehavior < Gemini::Behavior
      def self.require(not_used); end
      depends_on :ShouldNotRemoveBehavior
      declared_methods :should_be_removed, :should_also_be_removed
    end

    @game_object.add_behavior :ParentOfShouldNotRemoveBehavior
    @game_object.add_behavior :ShouldNotRemoveBehavior

    @game_object.remove_behavior :ParentOfShouldNotRemoveBehavior
    @game_object.should have_behavior(:ShouldNotRemoveBehavior)
  end
  
  it "adds its declared methods into the GameObject it is attached to when added" do
    class AddTestBehavior < Gemini::Behavior
      declared_methods :foo, :bar, :bazz
      def foo; end
      def bar; end
      def bazz; end
    end

    @game_object.add_behavior :AddTestBehavior
    
    @game_object.should respond_to(:foo)
    @game_object.should respond_to(:bar)
    @game_object.should respond_to(:bazz)
  end
  
  it "removes its declared methods when removed from a game object" do
    class RemoveTestBehavior < Gemini::Behavior
      declared_methods :foo, :bar, :bazz
    end
    @game_object.add_behavior :RemoveTestBehavior
    @game_object.remove_behavior :RemoveTestBehavior
    @game_object.should_not respond_to(:foo)
    @game_object.should_not respond_to(:bar)
    @game_object.should_not respond_to(:bazz)
  end
  
  it "forwards any unhandled method invocations to the GameObject it is attached to" do
    class ForwardTestBehavior < Gemini::Behavior
      declared_methods :foo, :bar, :bazz

      def load
        @target.oneword
        @target.underscore_case
        @target.camelCase
        @target.AllCaps
      end
    end
    
    @game_object.should_receive(:oneword)
    @game_object.should_receive(:underscore_case)
    @game_object.should_receive(:camelCase)
    @game_object.should_receive(:AllCaps)

    @game_object.add_behavior :ForwardTestBehavior
  end
end

describe Gemini::Behavior, ".wrap_with_callbacks" do
  it_should_behave_like "initial mock state"
  
  before :each do
    @game_object = Gemini::GameObject.new(@state)
  end

  it "accepts an array of symbols" do
    class ArrayOfSymbolsBehavior < Gemini::Behavior
      wrap_with_callbacks :foo, :bar
    end
  end
  
  it "renames wrapped methods to wrapped_<method>" do
    class RenameWrappedMethodsBehavior < Gemini::Behavior
      wrap_with_callbacks :foo=, :bar, :bazz, :quux, :quuux
      def foo=(arg1); end
      def bar; end
      def bazz(arg1); end
      def quux(arg1, arg2); end
      def quuux(arg1, *arg2); end
    end

    @game_object.add_behavior :RenameWrappedMethodsBehavior
    behavior = @game_object.instance_variable_get(:@__behaviors)[:RenameWrappedMethodsBehavior]
    behavior.should respond_to(:wrapped_foo=)
    behavior.should respond_to(:wrapped_bar)
    behavior.should respond_to(:wrapped_bazz)
    behavior.should respond_to(:wrapped_quux)
    behavior.should respond_to(:wrapped_quuux)
  end
  
  it "creates a wrapper method that calls the wrapped method" do
    class ForwardToWrappedMethodBehavior < Gemini::Behavior
      wrap_with_callbacks :foo, :bar, :baz, :baz=
      declared_methods :foo, :bar, :baz, :baz=
      def foo; end
      def bar; end
      def baz; end
      def baz=(value); end
    end

    @game_object.add_behavior :ForwardToWrappedMethodBehavior
    behavior = @game_object.instance_variable_get(:@__behaviors)[:ForwardToWrappedMethodBehavior]
    behavior.should_receive :wrapped_foo
    behavior.should_receive :wrapped_bar
    behavior.should_receive :wrapped_baz=
    @game_object.foo
    @game_object.bar
    @game_object.baz = 5
  end

  it "raises an error when <method>= is wrapped with no matching <method> on wrap_with_callbacks" do
    class RaisesWrapperErrorBehavior < Gemini::Behavior
      wrap_with_callbacks :baz=
      declared_methods :baz=
      
      def baz=(value); end
    end
    @game_object.add_behavior :RaisesWrapperErrorBehavior
    lambda {@game_object.baz = 6}.should raise_error(Gemini::InvalidWrapWithCallbacksError)
  end
  
  it "passes a block from the wrapper method through to the wrapped method" do
    class ForwardBlockToWrappedMethodsBehavior < Gemini::Behavior
      wrap_with_callbacks :method_that_takes_a_block
      declared_methods :method_that_takes_a_block
      
      def method_that_takes_a_block(&block)
        block.call(10)
      end
    end

    @game_object.add_behavior :ForwardBlockToWrappedMethodsBehavior
    value_to_be_changed_in_the_block = 0
    @game_object.method_that_takes_a_block do |new_value|
      value_to_be_changed_in_the_block = new_value
    end
    
    value_to_be_changed_in_the_block.should == 10
  end
  
  it "adds listener registration methods of the form on_before_<method> and on_after_<method> to target GameObject" do
    class ListenerRegistrationMethodsAddedBehavior < Gemini::Behavior
      wrap_with_callbacks :foo,:bar=
      def foo; end
      def bar=(value); end
    end

    @game_object.add_behavior :ListenerRegistrationMethodsAddedBehavior
    @game_object.should respond_to(:on_before_foo)
    @game_object.should respond_to(:on_after_foo)
    @game_object.should respond_to(:on_before_bar_changes)
    @game_object.should respond_to(:on_after_bar_changes)
  end
  
  it "adds a wrapper method that invokes callbacks before and after the wrapped method" do
    class CallbackInvokedByWrapperMethodBehavior < Gemini::Behavior
      wrap_with_callbacks :foo
      declared_methods :foo
      
      def foo; end
    end
    
    before_triggered = false
    after_triggered = false

    @game_object.add_behavior :CallbackInvokedByWrapperMethodBehavior

    @game_object.on_before_foo do
      before_triggered = true
    end
    
    @game_object.on_after_foo do
      after_triggered = true
    end
    
    @game_object.foo

    before_triggered.should be_true
    after_triggered.should be_true
  end
end