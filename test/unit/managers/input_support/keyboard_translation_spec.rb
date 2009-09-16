require "spec"

describe "Keyboard Translation" do
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

  it "translates :left_shift" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :left_shift
        end
      end
    end.should_not raise_error
  end

  it "translates :right_shift" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :right_shift
        end
      end
    end.should_not raise_error
  end

  it "translates 0-9" do
    (0..9).each do |number|
      lambda do
        Jemini::InputBuilder.declare do |i|
          i.in_order_to :jump do
            i.hold number
          end
        end
      end.should_not raise_error
    end
  end

  it "translates a-z" do
    ('a'..'z').each do |letter|
      lambda do
        Jemini::InputBuilder.declare do |i|
          i.in_order_to :jump do
            i.hold letter
          end
        end
      end.should_not raise_error
    end
  end

  it "translates :back" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :back
        end
      end
    end.should_not raise_error
  end

  it "translates :apostrophe" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :apostrophe
        end
      end
    end.should_not raise_error
  end

  it "translates :backslash" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :backslash
        end
      end
    end.should_not raise_error
  end

  it "translates :colon" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :colon
        end
      end
    end.should_not raise_error
  end

  it "translates :comma" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :comma
        end
      end
    end.should_not raise_error
  end

  it "translates :numpad_period" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :decimal
        end
      end
    end.should_not raise_error
  end

  it "translates :tab" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :tab
        end
      end
    end.should_not raise_error
  end

  it "translates numpad numbers" do
    (1..9).each do |n|
      lambda do
        Jemini::InputBuilder.declare do |i|
          i.in_order_to :jump do
            i.hold "numpad#{n}"
          end
        end
      end.should_not raise_error
    end
  end

  it "translates :left_arrow" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :left_arrow
        end
      end
    end.should_not raise_error
  end

  it "translates :right_arrow" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :right_arrow
        end
      end
    end.should_not raise_error
  end

  it "translates :up_arrow" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :up_arrow
        end
      end
    end.should_not raise_error
  end

  it "translates :down_arrow" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :down_arrow
        end
      end
    end.should_not raise_error
  end

  it "translates :left_ctrl" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :left_ctrl
        end
      end
    end.should_not raise_error
  end

  it "translates :right_ctrl" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :right_ctrl
        end
      end
    end.should_not raise_error
  end

  it "translates :left_alt" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :left_alt
        end
      end
    end.should_not raise_error
  end

  it "translates :right_alt" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :right_alt
        end
      end
    end.should_not raise_error
  end

  it "translates :left_bracket" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :left_bracket
        end
      end
    end.should_not raise_error
  end

  it "translates :right_bracket" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :right_bracket
        end
      end
    end.should_not raise_error
  end

  it "translates :minus" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :minus
        end
      end
    end.should_not raise_error
  end

  it "translates :equals" do
    lambda do
      Jemini::InputBuilder.declare do |i|
        i.in_order_to :jump do
          i.hold :equals
        end
      end
    end.should_not raise_error
  end



end