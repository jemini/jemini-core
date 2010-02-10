require 'spec_helper'
require 'behaviors/configurable'

describe 'Configurable' do

  before :each do
    @config_manager = mock('ConfigManager')
    @state = mock('MockState', :manager => @config_manager)
    @game_object = Jemini::GameObject.new(@state)
    @game_object.add_behavior :Configurable
  end
  
  describe "#configure_as" do
    
    it "parses config" do
      @config_manager.should_receive(:get_config).with(:tank).and_return("a = foo\nb = bar")
      @game_object.configure_as :tank
      @game_object.config[:a].should == "foo"
      @game_object.config[:b].should == "bar"
    end
    
    it "ignores comments in config" do
      @config_manager.should_receive(:get_config).with(:tank).and_return("#a = foo\nb = bar")
      @game_object.configure_as :tank
      @game_object.config[:a].should be_nil
      @game_object.config[:b].should == "bar"
    end
    
    it "treats numbers as numbers" do
      @config_manager.should_receive(:get_config).with(:tank).and_return("a = 1\nb = 2.0\nc=-3\nd=-4.0")
      @game_object.configure_as :tank
      @game_object.config[:a].should == 1
      @game_object.config[:b].should == 2.0
      @game_object.config[:c].should == -3
      @game_object.config[:d].should == -4.0
    end
    
    it "treats quoted numbers as strings" do
      @config_manager.should_receive(:get_config).with(:tank).and_return("a = \"1\"\nb = \"2.0\"\nc=\"-3\"\nd=\"-4.0\"")
      @game_object.configure_as :tank
      @game_object.config[:a].should == "1"
      @game_object.config[:b].should == "2.0"
      @game_object.config[:c].should == "-3"
      @game_object.config[:d].should == "-4.0"
    end
    
    it "treats quoted strings as strings" do
      @config_manager.should_receive(:get_config).with(:tank).and_return("a = \"foo\"\nb = \"bar\"")
      @game_object.configure_as :tank
      @game_object.config[:a].should == "foo"
      @game_object.config[:b].should == "bar"
    end
    
    it "treats escaped quotes as part of string" do
      @config_manager.should_receive(:get_config).with(:tank).and_return("a = \\\"foo\\\"\nb = \\\"bar\\\"")
      @game_object.configure_as :tank
      @game_object.config[:a].should == '"foo"'
      @game_object.config[:b].should == '"bar"'
    end
    
    it "treats escaped escape marks as part of string" do
      @config_manager.should_receive(:get_config).with(:tank).and_return("a = \\\\\"foo\\\\\"\nb = \\\\\"bar\\\\\"")
      @game_object.configure_as :tank
      @game_object.config[:a].should == '\\"foo\\"'
      @game_object.config[:b].should == '\\"bar\\"'
    end
    
    it "auto-sets attributes specified as config keys"
    
    it "does not attempt to set attributes for config keys that have no attribute methods"
    
  end
  
end
