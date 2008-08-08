require 'message_queue'

describe Gemini::MessageQueue do
  before :each do
    Gemini::MessageQueue.instance.stop_processing
    Gemini::MessageQueue.instance.send(:initialize)
  end
  
  after :each do
    
  end
  
  it "is a Singleton" do
    Gemini::MessageQueue.ancestors.member?(Singleton).should be_true
  end
  
  it "allows messages to be added to the queue" do
    Gemini::MessageQueue.instance.post_message(Gemini::Message.new(:test_type, "A test message"))
    Gemini::MessageQueue.instance.instance_variable_get("@messages").size.should == 1
    Gemini::MessageQueue.instance.post_message(Gemini::Message.new(:test_type2, "Another test message"))
    Gemini::MessageQueue.instance.instance_variable_get("@messages").size.should == 2
  end
  
  it "allows listeners to be added and removed" do
    Gemini::MessageQueue.instance.add_listener(:test_type, self, lambda{})
    Gemini::MessageQueue.instance.instance_variable_get("@listeners")[:test_type].size.should == 1
    Gemini::MessageQueue.instance.remove_listener(:test_type, self)
    Gemini::MessageQueue.instance.instance_variable_get("@listeners")[:test_type].size.should == 0
  end
  
  it "allows listener callbacks to be defined as a block" do
    Gemini::MessageQueue.instance.add_listener(:test_type, self) do
      #empty block
    end
    Gemini::MessageQueue.instance.instance_variable_get("@listeners")[:test_type].size.should == 1
  end
  
  it "notifies listener objects when a new message arrives" do
    
    callback_was_called = false
    Gemini::MessageQueue.instance.start_processing
    Gemini::MessageQueue.instance.add_listener(:test_type, self) { callback_was_called = true }
    Gemini::MessageQueue.instance.post_message(Gemini::Message.new(:test_type, "Some test message"))
    sleep 0.01
    callback_was_called.should be_true
  end
  
  it "allows new messages to be posted to the queue, even if messages are being processed" do
    callback_started = false
    blocking = true
    Gemini::MessageQueue.instance.add_listener(:test_type, self) do
      #Block until all the messages have been added
      callback_started = true
      while blocking
        sleep 0.001
      end
    end
    Gemini::MessageQueue.instance.start_processing
    Gemini::MessageQueue.instance.post_message(Gemini::Message.new(:test_type, "Some test message"))
    sleep 0.01
    callback_started.should be_true #First message has been consumed and is being proccessed
    Gemini::MessageQueue.instance.post_message(Gemini::Message.new(:test_type, "Some test message"))
    Gemini::MessageQueue.instance.post_message(Gemini::Message.new(:test_type, "Some test message"))
    Gemini::MessageQueue.instance.post_message(Gemini::Message.new(:test_type, "Some test message"))
    sleep 0.01 #Show that sufficient time has elapsed to process these messages if the callback wasn't blocking
    Gemini::MessageQueue.instance.instance_variable_get("@messages").size.should == 3
    blocking = false
    sleep 0.01
    Gemini::MessageQueue.instance.instance_variable_get("@messages").size.should == 0
  end
end