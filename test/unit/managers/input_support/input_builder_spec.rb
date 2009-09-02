require 'spec_helper'
require 'managers/input_manager'
require 'managers/input_support/input_builder'
require 'managers/message_queue'

describe 'InputBuilder' do
  it_should_behave_like "initial mock state"
  before do
    @raw_input = mock(:MockContainerInput, :add_listener => nil, :poll => nil)
    @container = mock(:MockContainer, :input => @raw_input)
    @input_manager = Jemini::InputManager.new(@state, @container)
    @state.stub!(:manager).with(:input).and_return(@input_manager)
    @message_queue = Jemini::MessageQueue.new(@state)
    @state.stub!(:manager).with(:message_queue).and_return(@message_queue)
  end

  describe '.declare' do
    it 'allows mappings to be declared' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :a
        end
      end

      Jemini::BaseState.active_state.manager(:input).listeners.should have(1).listener
    end
  end
  
  describe '#in_order_to' do
    it 'binds keyboard keys with the name of the key' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :a
        end
      end

      Jemini::BaseState.active_state.manager(:input).listeners.first.device.should == :key
    end

    it 'allows bindings to be turned off with #off'
    
    it 'appends multiple bindings for the same action'
    
    it 'appends multiple bindings inside the same binding' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :a
          i.hold :b
        end
      end

      Jemini::BaseState.active_state.manager(:input).listeners.should have(2).listeners
    end


    it 'binds left, right, and middle mouse buttons'
    it 'binds scroll up and scroll down mouse buttons'
    it 'can bind to a given mouse button number'
    it 'can bind to a given xbox number'
  end

  describe '#axis_update' do
    it 'creates a binding that fires on every update with the new position of the axis'
    it 'works with joystick axes'
    it 'works with the mouse position'
  end

  describe '#release' do
    it 'creates a binding that fires when the button is released'
  end

  describe '#press' do
    it 'creates a binding that fires when the button is pressed' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.press :a
        end
      end

      @raw_input.stub!(:is_key_pressed).and_return true
      
      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :ReceivesEvents
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
    it 'creates a binding that fires on each update while the button is held' do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :run do
          i.hold :left_arrow
        end
      end

      @raw_input.stub!(:is_key_down).and_return true

      game_object = Jemini::GameObject.new(@state)
      game_object.add_behavior :ReceivesEvents
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