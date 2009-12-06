require 'spec_helper'
require 'managers/config_manager'

describe 'ConfigManager' do

  before :each do
    @config_manager = ConfigManager.new(@state)
    @resource_manager = ResourceManager.new(@state)
    @resource_manager.stub!(:load_resource).and_return(mock('Resource'))

    @state.stub!(:manager).with(:resource).and_return(@resource_manager)
    @state.stub!(:manager).with(:config).and_return(@config_manager)
  end
  
  describe "#get_config" do

    it "loads configuration" do
      config = mock('Config')
      @resource_manager.should_receive(:get_config).with(:tank).and_return(config)
      @config_manager.get_config :tank
    end

  end
      
end
