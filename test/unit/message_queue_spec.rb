require 'spec_helper'
require 'managers/message_queue'

describe Jemini::MessageQueue do
  it_should_behave_like "initial mock state"
  
  before :each do
    @message_queue = Jemini::MessageQueue.new(@state)
    @state.stub!(:manager).with(:message_queue).and_return(@message_queue)
  end

  after :each do
    
  end
  
  it "allows messages to be added to the queue" do
    @message_queue.post_message(Jemini::Message.new(:test_type, "A test message"))
    @message_queue.instance_variable_get("@messages").should have(1).messages
    @message_queue.post_message(Jemini::Message.new(:test_type2, "Another test message"))
    @message_queue.instance_variable_get("@messages").should have(2).messages
  end
  
  it "allows listeners to be added and removed" do
    @message_queue.add_listener(:test_type, self, lambda{})
    @message_queue.instance_variable_get("@listeners")[:test_type].should have(1).listener
    @message_queue.remove_listener(:test_type, self)
    @message_queue.instance_variable_get("@listeners")[:test_type].should have(0).listeners
  end
  
  it "allows listener callbacks to be defined as a block" do
    @message_queue.add_listener(:test_type, self) do
      #empty block
    end
    @message_queue.instance_variable_get("@listeners")[:test_type].size.should == 1
  end
  
  it "notifies listener objects when a new message arrives" do
    callback_was_called = false
    @message_queue.add_listener(:test_type, self) { callback_was_called = true }
    @message_queue.post_message(Jemini::Message.new(:test_type, "Some test message"))
    @message_queue.process_messages(1)
    callback_was_called.should be_true
  end

  it "notifies listener objects when the object's 'events_for' matches the messages 'to'" do
    right_callback_was_called = false
    wrong_callback_was_called = false
    @right_game_object = Jemini::GameObject.new(@state)
    @right_game_object.add_behavior :HandlesEvents
    @right_game_object.handles_events_for :ponies
    @right_game_object.handle_event(:test_type) { right_callback_was_called = true}

    @wrong_game_object = Jemini::GameObject.new(@state)
    @wrong_game_object.add_behavior :HandlesEvents
    @wrong_game_object.handle_event(:test_type) { wrong_callback_was_called = true}

    message = Jemini::Message.new(:test_type, "Some test message")
    message.to = :ponies
    @message_queue.post_message(message)
    @message_queue.process_messages(1)
    right_callback_was_called.should be_true
    wrong_callback_was_called.should be_false
  end
  
  it "allows new messages to be posted to the queue, even if messages are being processed" do
    @message_queue.post_message(Jemini::Message.new(:chain_message, "Will kick off a message"))
    @message_queue.add_listener(:chain_message, self) { @message_queue.post_message(Jemini::Message.new(:chained_message, "Will be added while processing"))}
    chained_message_sent = chain_message_sent = false
    @message_queue.add_listener(:chain_message, self) { chain_message_sent = true }
    @message_queue.add_listener(:chained_message, self) { chained_message_sent = true }
    @message_queue.process_messages(1)
    (chain_message_sent && chained_message_sent).should be_true
  end
end
