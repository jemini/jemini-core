require 'spec_helper'
require 'managers/resource_manager'
require 'fileutils'

describe 'ResourceManager' do

  describe "#load_resources" do
    
    describe "with global assets" do

      before :each do
        @state = Jemini::BaseState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
        @resource_manager = ResourceManager.new(@state)
        @state.send(:set_manager, :resource, @resource_manager) #send lets us call a private method.
      end
    
      it "loads assets from global data directory" do
        @resource_manager.data_directory = "test/data/loads_global"
        @resource_manager.should_receive(:cache_image).with(:test, "test/data/loads_global/test.png")
        @resource_manager.load_resources
      end
  
      it "raises an error when accessing an asset that doesn't exist" do
        @resource_manager.data_directory = "test/data/existence"
        @resource_manager.load_resources
        lambda{@resource_manager.get_image(:foobar)}.should raise_error
      end
  
      it "loads png files" do
        @resource_manager.data_directory = "test/data/loads_png"
        @resource_manager.should_receive(:cache_image).with(:test, "test/data/loads_png/test.png")
        @resource_manager.load_resources
      end
    
      it "loads gif files" do
        @resource_manager.data_directory = "test/data/loads_gif"
        @resource_manager.should_receive(:cache_image).with(:gif, "test/data/loads_gif/gif.gif")
        @resource_manager.load_resources
      end
    
      it "loads wav files" do
        @resource_manager.data_directory = "test/data/loads_wav"
        @resource_manager.should_receive(:cache_sound).with(:test, "test/data/loads_wav/test.wav")
        @resource_manager.load_resources
      end
    
      it "warns if multiple formats with the same name are found, but loads one anyway" do
        @resource_manager.data_directory = "test/data/warns_of_duplicates"
        @resource_manager.log.should_receive(:warn).with(/duplicate/)
        @resource_manager.load_resources
      end
    
      it "warns if xcf files are found"
      it "warns if psd files are found"
      
    end
    
    describe "with state-specific assets" do

      before :each do
        class FooState < Jemini::BaseState; end
        @foo_state = FooState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
        @resource_manager = ResourceManager.new(@state)
        @foo_state.send(:set_manager, :resource, @resource_manager) #send lets us call a private method.
      end

      it "loads assets from data subdirectory with same name as current state" do
        @resource_manager.data_directory = "test/data/state_specific"
        @resource_manager.should_receive(:cache_image).with(:i_exist_only_in_foo, "test/data/state_specific/foo/i_exist_only_in_foo.png")
        @resource_manager.load_resources
      end

      it "does not load global assets with the same name as a state asset" do
        #test/data/foo/also_global.png is a 3x3 image.
        #test/data/also_global.png is a 2x2 image.
        @resource_manager.data_directory = "test/data/state_and_global"
        @resource_manager.load_resources
        @resource_manager.should_receive(:cache_image).with(:also_global, "test/data/state_and_global/foo/also_global.png")
        @resource_manager.should_not_receive(:cache_image).with(:also_global, "test/data/state_and_global/also_global.png")
      end

    end
    
  end
  
  describe "#cache_image" do
    it "stores an image for retrieval"
    it "loads gif files"
    it "loads png files"
  end
  describe "#get_image" do
    it "raises an error if asked for an unknown image"
  end
        
  describe "#cache_sound" do
    it "stores an sound for retrieval"
    it "loads wav files"
    it "loads ogg files"
  end
  describe "#get_sound" do
    it "raises an error if asked for an unknown sound"
  end
        
end
