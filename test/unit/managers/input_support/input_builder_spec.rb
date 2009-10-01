require 'spec_helper'
require 'managers/input_manager'
require 'managers/input_support/input_builder'
require 'managers/message_queue'
require 'game_state'

describe 'InputBuilder' do
  it_should_behave_like "initial mock state"

  before do
    @raw_input = mock(:MockContainerInput, :add_listener => nil, :poll => nil)
    @container.stub!(:input).and_return @raw_input
    @input_manager = Jemini::InputManager.new(@state, @container)
    @state.stub!(:manager).with(:input).and_return(@input_manager)
    @message_queue = Jemini::MessageQueue.new(@state)
    @state.stub!(:manager).with(:message_queue).and_return(@message_queue)
    Jemini::GameState.stub!(:active_state).and_return @state
    @state.stub!(:screen_size).and_return Vector.new(640, 480)
    Jemini::InputManager.stub!(:loading_input_manager).and_return @input_manager
  end

  describe '.declare' do
    it 'allows mappings to be declared' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :a
        end
      end
      
      Jemini::GameState.active_state.manager(:input).listeners.should have(1).listener
    end
  end

  describe '#for' do
    it 'sets the destination ID for inputs inside its block' do
      pending
      Jemini::InputBuilder.declare do |i|
        i.for :player_1 do
          i.in_order_to :fire do
            i.press :space
          end
        end
      end

      called = false
      # the message queue reshapes exceptions, which will cause errors for failed assertions in RSpec to silently die
      to     = nil
      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handles_events_for :player_1
      game_object.handle_event :fire do |event|
        called = true
        to = event.to
      end

      @raw_input.stub!(:is_key_pressed).and_return true
      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10

      called.should be_true
      to.should == :player_1
    end
  end

  describe '#in_order_to' do
    describe 'destinations' do
      it 'Allows a destination ID to be specified' do
        Jemini::InputBuilder.declare do |i|
          i.in_order_to :fire do
            i.press :space, :to => :player_1
          end
        end

        called = false
        # the message queue reshapes exceptions, which will cause errors for failed assertions in RSpec to silently die
        to     = nil
        game_object = Jemini::GameObject.new(@state)
        game_object.add_behavior :HandlesEvents
        game_object.handles_events_for :player_1
        game_object.handle_event :fire do |event|
          called = true
          to = event.to
        end

        @raw_input.stub!(:is_key_pressed).and_return true
        @input_manager.poll(200, 200, 10)
        @message_queue.process_messages 10

        called.should be_true
        to.should == :player_1
      end
    end

    describe 'custom values' do
      it 'Allows values to directly be injected from the input declaration' do
        Jemini::InputBuilder.declare do |i|
          i.in_order_to :jump do
            i.hold :a, :value => 1.0
          end
        end

        game_object = Jemini::GameObject.new(@state)
        game_object.add_behavior :HandlesEvents
        game_object.handle_event :jump do |event|
          @called = true
          event.value.should == 1.0
        end

        @raw_input.stub!(:is_key_down).and_return true
        @input_manager.poll(200, 200, 10)
        @message_queue.process_messages 10
        
        @called.should be_true
      end
    end

    it 'binds keyboard keys with the name of the key' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :a
        end
      end

      Jemini::GameState.active_state.manager(:input).listeners.first.device.should == :key
    end

    it 'allows bindings to be turned off with #off'

    it 'appends multiple bindings for the same action' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :a
        end
      end

      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :b
        end
      end

      Jemini::GameState.active_state.manager(:input).listeners.should have(2).listeners
    end

    it 'appends multiple bindings inside the same binding' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :a
          i.hold :b
        end
      end

      Jemini::GameState.active_state.manager(:input).listeners.should have(2).listeners
    end


    it 'binds the left mouse button by name' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :fire_primary do
          i.press :mouse_left
        end

        i.in_order_to :fire_secondary do
          i.press :mouse_button => 1
        end
      end

      @raw_input.stub!(:mouse_x).and_return 0
      @raw_input.stub!(:mouse_y).and_return 0
      @raw_input.stub!(:mouse_pressed?).with(0).and_return true
      @raw_input.stub!(:mouse_pressed?).with(1).and_return false

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :fire_primary do
        @primary = true
      end
      game_object.handle_event :fire_secondary do
        @secondary = true
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10

      @primary.should be_true
      @secondary.should be_nil
    end

    it 'binds the right mouse button by name' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :fire_primary do
          i.press :mouse_left
        end

        i.in_order_to :fire_secondary do
          i.press :mouse_right
        end
      end

      @raw_input.stub!(:mouse_x).and_return 0
      @raw_input.stub!(:mouse_y).and_return 0
      @raw_input.stub!(:mouse_pressed?).with(0).and_return false
      @raw_input.stub!(:mouse_pressed?).with(1).and_return true

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :fire_primary do
        @primary = true
      end
      game_object.handle_event :fire_secondary do
        @secondary = true
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10

      @primary.should be_nil
      @secondary.should be_true
    end

    it 'binds the middle mouse button by name' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :fire_primary do
          i.press :mouse_left
        end

        i.in_order_to :use do
          i.press :mouse_middle
        end
      end

      @raw_input.stub!(:mouse_x).and_return 0
      @raw_input.stub!(:mouse_y).and_return 0
      @raw_input.stub!(:mouse_pressed?).with(0).and_return false
      @raw_input.stub!(:mouse_pressed?).with(2).and_return true

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :fire_primary do
        @primary = true
      end
      game_object.handle_event :use do
        @use = true
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10

      @primary.should be_nil
      @use.should be_true
    end

    it 'binds scroll up and scroll down mouse buttons'

    it 'can bind to a given mouse button number' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :fire_primary do
          i.press :mouse_button => 0
        end

        i.in_order_to :fire_secondary do
          i.press :mouse_button => 1
        end
      end

      @raw_input.stub!(:mouse_x).and_return 0
      @raw_input.stub!(:mouse_y).and_return 0
      @raw_input.stub!(:mouse_pressed?).with(0).and_return true
      @raw_input.stub!(:mouse_pressed?).with(1).and_return false

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :fire_primary do
        @primary = true
      end
      game_object.handle_event :fire_secondary do
        @secondary = true
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10

      @primary.should be_true
      @secondary.should be_nil
    end

    it 'can bind to a given xbox number'
  end

  describe '#move' do
    it 'creates a binding that fires on every update with the new position of the axis' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :steer do
          i.move :mouse
        end
      end

      @raw_input.stub!(:mouse_x).and_return 40
      @raw_input.stub!(:mouse_y).and_return 50

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.add_behavior :Spatial
      game_object.handle_event :steer do |event|
        game_object.position = event.value.screen_position
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10

#      game_object.position.should == Vector.new(40, 50)
    end

    it 'works with joystick axes'

    it 'works with the mouse position' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :steer do
          i.move :mouse
        end
      end

      @raw_input.stub!(:mouse_x).and_return 40
      @raw_input.stub!(:mouse_y).and_return 50

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.add_behavior :Spatial
      game_object.handle_event :steer do |event|
        game_object.position = event.value.screen_position
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10

      game_object.position.should == Vector.new(40, 50)
    end
  end


  describe '#release' do
    it 'creates a binding that fires when the mouse is released' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :place_token do
          i.release :mouse_left
        end
      end

      @raw_input.stub!(:mouse_x).and_return 0
      @raw_input.stub!(:mouse_y).and_return 0
      @raw_input.stub!(:mouse_button_down?).and_return true

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :place_token do
        @pass = true
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_nil

      @pass = false # reset
      @raw_input.stub!(:mouse_button_down?).and_return false

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_true
    end

    it 'creates a binding that fires when the key is released' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :place_token do
          i.release :space
        end
      end

      @raw_input.stub!(:is_key_down).and_return true

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :place_token do
        @pass = true
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_nil

      @pass = false # reset
      @raw_input.stub!(:is_key_down).and_return false

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_true
    end
  end

  describe '#press' do
    it 'creates a binding that fires when the mouse is pressed' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :shoot do
          i.press :mouse_left
        end
      end

      @raw_input.stub!(:mouse_x).and_return 0
      @raw_input.stub!(:mouse_y).and_return 0
      @raw_input.stub!(:mouse_pressed?).and_return true

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :shoot do
        @pass = true
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_true
    end

    it 'creates a binding that fires when the key is pressed' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.press :a
        end
      end

      @raw_input.stub!(:is_key_pressed).and_return true

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :jump do
        @pass = true
      end

      # simulate pressing 'a'
      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_true
    end
  end

  describe '#hold' do
    it 'creates a binding that fires on each update while the mouse is held' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :run do
          i.hold :mouse_left
        end
      end

      @raw_input.stub!(:mouse_x).and_return 0
      @raw_input.stub!(:mouse_y).and_return 0
      @raw_input.stub!(:mouse_button_down?).and_return true

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :run do
        @pass = true
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_true

      @pass = false # reset

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_true
    end

    it 'creates a binding that fires on each update while the key is held' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :run do
          i.hold :left_arrow
        end
      end

      @raw_input.stub!(:is_key_down).and_return true

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :HandlesEvents
      game_object.handle_event :run do
        @pass = true
      end

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_true

      @pass = false # reset

      @input_manager.poll(200, 200, 10)
      @message_queue.process_messages 10
      @pass.should be_true
    end
  end

  #TODO: Create a Chargable behavior that integrates with this binding type
  #      Charge will fire decorated events at the press and release of the charge
  #      Chargable will see these and know how to handle them.
  #      This is so we can play sounds and show graphics when a charge starts
  #      Or maybe we just have a matching pressed?
  describe '#charge' do
    it 'creates a binding that fires when the button is released'
    it 'uses a special event that measures the duration of the charge thus far'
    it 'auto releases after a given time if it is given with :auto_release (in seconds)'
    it 'stops charging the duration if :max is given (in seconds)'
  end

  describe 'modifier keys' do
    it 'fires if the modifier key is being held while the desired button is invoked'
    it 'can handle multiple modifier keys' # :shift_alt_tab
    it 'detects a modifier key only at the beginning of the binding name' # :alt_tab
  end

  describe 'binding sequences' do
    # let's hold off on this one for a while.
    it 'allows for sequential bindings with #and_then'
  end
end