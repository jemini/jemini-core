require 'spec_helper'
require 'behavior'

JEMINI_VERSION = "1.0.0"

describe Jemini::Behavior do
  it_should_behave_like "initial mock state"

  before :each do
    @game_object = Jemini::GameObject.new(@state)
  end

  it "can declare class-level listeners" do
    class ListeningBehavior < Jemini::Behavior
      listen_for :event

      def fire_event
        @game_object.notify :event
      end
    end

    @game_object.add_behavior :ListeningBehavior
    @callback_invoked_with_block = false
    @game_object.on_event do
      @callback_invoked_with_block = true
    end

    @callback_invoked_with_block.should be_false
    @game_object.fire_event
    @callback_invoked_with_block.should be_true
  end

  it "can declare dependant behaviors" do
    class DeclareDependantBehavior < Jemini::Behavior
      def self.require(not_used); end
      depends_on :dependency
    end
  end
  
  it "can declare kind_of dependant behaviors" do
    class DeclareKindOfDependantBehavior < Jemini::Behavior
      depends_on_kind_of :dependency
    end
  end
  
  it "calls load upon instantiation" do
    class CallsLoad < Jemini::Behavior
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
    class CallsUnload < Jemini::Behavior

      def calls_unload_behavior
        self
      end
    end

    @game_object.add_behavior :CallsUnload
    @game_object.calls_unload_behavior.should_receive :unload
    @game_object.remove_behavior :CallsUnload
  end
  
  it "loads its dependant behaviors when initializing" do
    class Dependency1 < Jemini::Behavior
      def has_loaded_dep1?
        @was_called
      end
      def load
        @was_called = true
      end
    end
    
    class Dependency2 < Jemini::Behavior
      def has_loaded_dep2?
        @was_called
      end
      def load
        @was_called = true
      end
    end
    
    class DependentLoadBehavior < Jemini::Behavior
      def self.require(not_used); end
      depends_on :Dependency1
      depends_on :Dependency2
    end
    
    @game_object.add_behavior :DependentLoadBehavior
    @game_object.should have_loaded_dep1
    @game_object.should have_loaded_dep2
  end
  
  it "removes its dependant behaviors if not in use by another behavior" do
    class RemovalBehavior < Jemini::Behavior; end
    
    class ParentOfRemovalBehavior < Jemini::Behavior
      def self.require(not_used); end
      depends_on :RemovalBehavior
    end

    @game_object.add_behavior :ParentOfRemovalBehavior
    @game_object.remove_behavior :ParentOfRemovalBehavior
    @game_object.should_not have_behavior(:RemovalBehavior)
  end
  
  it "doesn't remove dependent behaviors when it is removed" do
    pending JEMINI_VERSION == "1.1.0"
    class ShouldNotRemoveBehavior < Jemini::Behavior
    end
    
    class ParentOfShouldNotRemoveBehavior < Jemini::Behavior
      def self.require(not_used); end
      depends_on :ShouldNotRemoveBehavior
    end

    @game_object.add_behavior :ParentOfShouldNotRemoveBehavior
    @game_object.add_behavior :ShouldNotRemoveBehavior

    @game_object.remove_behavior :ParentOfShouldNotRemoveBehavior
    @game_object.should have_behavior(:ShouldNotRemoveBehavior)
  end

  it "adds its public instance methods to the game object it is attached to when added" do
    class AddPublicTestBehavior < Jemini::Behavior
      def foo; end
      def bar; end
      def bazz; end
    end
    @game_object.add_behavior :AddPublicTestBehavior

    @game_object.should respond_to(:foo)
    @game_object.should respond_to(:bar)
    @game_object.should respond_to(:bazz)
  end

  it "private methods are not added to the game object" do
    class DoNotAddPrivateTestBehavior < Jemini::Behavior
      private
      def foo; end
      def bar; end
      def bazz; end
    end

    @game_object.add_behavior :DoNotAddPrivateTestBehavior

    @game_object.should_not respond_to(:foo)
    @game_object.should_not respond_to(:bar)
    @game_object.should_not respond_to(:bazz)
  end

  it "removes its public instance methods from the game object it is attached to when removed" do
    class RemovePublicsTestBehavior < Jemini::Behavior
      def foo; end
      def bar; end
      def bazz; end
    end

    @game_object.add_behavior :RemovePublicsTestBehavior

    @game_object.should respond_to(:foo)
    @game_object.should respond_to(:bar)
    @game_object.should respond_to(:bazz)

    @game_object.remove_behavior :RemovePublicsTestBehavior

    @game_object.should_not respond_to(:foo)
    @game_object.should_not respond_to(:bar)
    @game_object.should_not respond_to(:bazz)
  end

  it "doesn't attach load and unload methods to the game object" do
    class SpecialMethodsTestBehavior < Jemini::Behavior
      def load; end
      def unload; end
    end

    lambda { @game_object.add_behavior :SpecialMethodsTestBehavior }.should_not raise_error(Jemini::MethodExistsError)
  end
  
  it "has a reference of the game object (@game_object)" do
    class ForwardTestBehavior < Jemini::Behavior

      def load
        @game_object.oneword
        @game_object.underscore_case
        @game_object.camelCase
        @game_object.AllCaps
      end
    end
    
    @game_object.should_receive(:oneword)
    @game_object.should_receive(:underscore_case)
    @game_object.should_receive(:camelCase)
    @game_object.should_receive(:AllCaps)

    @game_object.add_behavior :ForwardTestBehavior
  end
end

describe Jemini::Behavior, "callback registration" do
  it_should_behave_like "initial mock state"

  before :each do
    @game_object = Jemini::GameObject.new(@state)
  end

  it "can register on_foo callbacks with blocks" do
    @game_object.add_behavior :Updates
    @callback_invoked_with_block = false
    @game_object.on_update { @callback_invoked_with_block = true }
    @callback_invoked_with_block.should be_false
    @game_object.update(0)
    @callback_invoked_with_block.should be_true
  end

  it "can register on_foo callbacks with a method name" do
    @game_object.add_behavior :Updates
    @game_object.on_update :handle_update
    @game_object.should_receive :handle_update
    @game_object.update(0)
  end

  it "can register before_foo callbacks with a method name" do
    class BeforeFooCallbackBehavior < Jemini::Behavior
      wrap_with_callbacks :foo
      def foo;end
    end
    @game_object.add_behavior :BeforeFooCallbackBehavior
    @game_object.on_before_foo :handle_before_foo
    @game_object.should_receive :handle_before_foo
    @game_object.foo
  end

  it "can register after_foo callbacks with a method name" do
    class AfterFooCallbackBehavior < Jemini::Behavior
      wrap_with_callbacks :foo
      def foo;end
    end
    @game_object.add_behavior :AfterFooCallbackBehavior
    @game_object.on_after_foo :handle_before_foo
    @game_object.should_receive :handle_before_foo
    @game_object.foo
  end

  it "can register changes callbacks with a method name" do
    class FooChangesCallbackBehavior < Jemini::Behavior
      wrap_with_callbacks :foo=
      def foo=(not_used);end
      def foo; end
    end
    @game_object.add_behavior :FooChangesCallbackBehavior
    @game_object.on_before_foo_changes :handle_before_foo
    @game_object.should_receive(:handle_before_foo).with(an_instance_of(Jemini::ValueChangedEvent)) do |event|
      event.previous_value.should be_nil
      event.desired_value.should == "bar"
    end
    @game_object.on_after_foo_changes :handle_after_foo
    @game_object.should_receive(:handle_after_foo).with(an_instance_of(Jemini::ValueChangedEvent)) do |event|
      event.previous_value.should be_nil
      event.desired_value.should == "bar"
    end
    @game_object.foo = "bar"
  end
end

describe Jemini::Behavior, ".wrap_with_callbacks" do
  it_should_behave_like "initial mock state"
  
  before :each do
    @game_object = Jemini::GameObject.new(@state)
  end

  it "accepts an array of symbols" do
    class ArrayOfSymbolsBehavior < Jemini::Behavior
      wrap_with_callbacks :foo, :bar
    end
  end
  
  it "renames wrapped methods to wrapped_<method>" do
    class RenameWrappedMethodsBehavior < Jemini::Behavior
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
    class ForwardToWrappedMethodBehavior < Jemini::Behavior
      wrap_with_callbacks :foo, :bar, :baz, :baz=
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
    class RaisesWrapperErrorBehavior < Jemini::Behavior
      wrap_with_callbacks :baz=
      
      def baz=(value); end
    end
    @game_object.add_behavior :RaisesWrapperErrorBehavior
    lambda {@game_object.baz = 6}.should raise_error(Jemini::InvalidWrapWithCallbacksError)
  end
  
  it "passes a block from the wrapper method through to the wrapped method" do
    class ForwardBlockToWrappedMethodsBehavior < Jemini::Behavior
      wrap_with_callbacks :method_that_takes_a_block
      
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
    class ListenerRegistrationMethodsAddedBehavior < Jemini::Behavior
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
    class CallbackInvokedByWrapperMethodBehavior < Jemini::Behavior
      wrap_with_callbacks :foo
      
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