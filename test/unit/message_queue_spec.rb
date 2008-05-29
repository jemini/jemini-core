require 'message_queue'

describe MessageQueue do
  before :each do
    MessageQueue.instance.stop_processing
    MessageQueue.instance.send(:initialize)
  end
  
  after :each do
    
  end
  
  it "is a Singleton" do
    MessageQueue.ancestors.member?(Singleton).should be_true
  end
  
  it "allows messages to be added to the queue" do
    MessageQueue.instance.post_message(:test_type, "A test message")
    MessageQueue.instance.instance_variable_get("@messages").size.should == 1
    MessageQueue.instance.post_message(:test_type2, "Another test message")
    MessageQueue.instance.instance_variable_get("@messages").size.should == 2
  end
  
  it "allows listeners to be added and removed" do
    MessageQueue.instance.add_listener(:test_type, self, lambda{})
    MessageQueue.instance.instance_variable_get("@listeners")[:test_type].size.should == 1
    MessageQueue.instance.remove_listener(:test_type, self)
    MessageQueue.instance.instance_variable_get("@listeners")[:test_type].size.should == 0
  end
  
  it "allows listener callbacks to be defined as a block" do
    MessageQueue.instance.add_listener(:test_type, self) do
      #empty block
    end
    MessageQueue.instance.instance_variable_get("@listeners")[:test_type].size.should == 1
  end
  
  it "notifies listener objects when a new message arrives" do
    class CallbackTest
      attr_reader :test_value
      def callback_method(type, message)
        @test_value = true
      end
    end
    callback = CallbackTest.new
    MessageQueue.instance.start_processing
    MessageQueue.instance.add_listener(:test_type, self, callback.method(:callback_method))
    MessageQueue.instance.post_message(:test_type, "Some test message")
    sleep 0.01
    callback.test_value.should be_true
  end
  
  it "allows new messages to be posted to the queue, even if messages are being processed" do
    callback_started = false
    blocking = true
    MessageQueue.instance.add_listener(:test_type, self) do
      #Block until all the messages have been added
      callback_started = true
      while blocking
        sleep 0.001
      end
    end
    MessageQueue.instance.start_processing
    MessageQueue.instance.post_message(:test_type, "Some test message")
    sleep 0.01
    callback_started.should be_true #First message has been consumed and is being proccessed
    MessageQueue.instance.post_message(:test_type, "Some test message")
    MessageQueue.instance.post_message(:test_type, "Some test message")
    MessageQueue.instance.post_message(:test_type, "Some test message")
    sleep 0.01 #Show that sufficient time has elapsed to process these messages if the callback wasn't blocking
    MessageQueue.instance.instance_variable_get("@messages").size.should == 3
    blocking = false
    sleep 0.01
    MessageQueue.instance.instance_variable_get("@messages").size.should == 0
  end
end