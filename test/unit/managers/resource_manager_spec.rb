require 'spec_helper'
require 'managers/resource_manager'
require 'fileutils'

describe 'ResourceManager' do

  describe "#load_resources" do
    it_should_behave_like "initial mock state"

    before :each do
      @resource_manager = ResourceManager.new(@state)
      @resource_manager.stub!(:load_resource).and_return(mock('Resource'))
    end

    describe "with global assets" do

      it "loads assets from global data directory" do
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_global_assets/data')
        @resource_manager.images.should have(0).images
        @resource_manager.load_resources
        @resource_manager.images.should have(1).image
      end
  
      it "raises an error when accessing an asset that doesn't exist" do
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_no_assets/data')
        @resource_manager.load_resources
        lambda{@resource_manager.get_image(:foobar)}.should raise_error
      end
  
      it "loads ini files" do
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_ini/data') #TODO: Refactor Jemini::Resource.
        @resource_manager.configs.should have(0).configs
        @resource_manager.load_resources
        @resource_manager.configs.should have(1).config
      end

      it "loads png files" do
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_pngs/data')
        @resource_manager.images.should have(0).images
        @resource_manager.load_resources
        @resource_manager.images.should have(1).image
      end
    
      it "loads gif files" do
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_gifs/data')
        @resource_manager.images.should have(0).images
        @resource_manager.load_resources
        @resource_manager.images.should have(1).image
      end
    
      it "loads wav files" do
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_wavs/data')
        @resource_manager.sounds.should have(0).sounds
        @resource_manager.load_resources
        @resource_manager.sounds.should have(1).sound
      end
    
      it "loads ogg files" do
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_oggs/data')
        @resource_manager.songs.should have(0).songs
        @resource_manager.load_resources
        @resource_manager.songs.should have(1).song
      end
    
      it "warns if multiple formats with the same name are found, but loads one anyway" do
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_duplicate_assets/data')
        @resource_manager.log.should_receive(:warn).with(/duplicate/)
        @resource_manager.load_resources
      end
    
      it "warns if invalid files are found" do
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_unsupported_assets/data')
        @resource_manager.log.should_receive(:warn).with(/xcf/)
        @resource_manager.log.should_receive(:warn).with(/psd/)
        @resource_manager.load_resources
      end
      
      it "will not override an existing asset, unlike state-specific assets"
      
    end
    
    describe "with state-specific assets" do

      it "loads assets from data subdirectory with same name as current state" do
        @state.stub!(:name).and_return 'per_state_assets'
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_per_state_assets/data')
        @resource_manager.images.should have(0).images
        @resource_manager.load_resources
        @resource_manager.images.should have(1).image
      end

      it "does not load global assets with the same name as a state asset" do
        pending
        @state.stub!(:name).and_return 'overridden'
        Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_overridden_assets/data')
        @resource_manager.log.should_receive(:warn).with(/duplicate image/)
        @resource_manager.images.should have(0).images
        @resource_manager.load_resources
        @resource_manager.images.should have(1).image
      end
      
      it "will override an existing asset, unlike global assets"

    end
    
  end
  
end
