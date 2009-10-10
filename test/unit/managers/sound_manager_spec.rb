require 'spec_helper'
require 'managers/sound_manager'

describe 'SoundManager' do
  it_should_behave_like 'initial mock state'
  before :each do
    @sound_manager = SoundManager.new(@state)
    @resource_manager = ResourceManager.new(@state)
    @resource_manager.stub!(:load_resource).and_return(mock('Resource'))

    @state.stub!(:manager).with(:resource).and_return(@resource_manager)
    @state.stub!(:manager).with(:sound).and_return(@sound_manager)
  end
  
  describe "#play_sound" do

    it "plays back cached sounds" do
      sound = mock('Sound')
      @resource_manager.should_receive(:get_sound).with(:boom).and_return(sound)
      sound.should_receive(:play)
      @sound_manager.play_sound :boom
    end

  end
  
  describe "#play_song" do
  
    it "plays songs at desired volume" do
      song = mock('Music')
      @resource_manager.should_receive(:get_song).with(:lala).and_return(song)
      song.should_receive(:play)
      song.should_receive(:volume=).with(0.5)
      @sound_manager.play_song(:lala, 0.5)
    end
    
    it "can loop songs" do
      song = mock('Music')
      @resource_manager.should_receive(:get_song).with(:lalalala).and_return(song)
      song.should_receive(:loop)
      song.should_receive(:volume=).with(0.5)
      @sound_manager.loop_song(:lalalala, 0.5)
    end
    
    it "halts presently playing song if a new one is requested" do
      song1 = mock('Music')
      song1.should_receive(:play)
      @resource_manager.should_receive(:get_song).with(:song1).and_return(song1)
      @sound_manager.play_song(:song1)
      song2 = mock('Music', :null_object => true)
      song1.should_receive(:stop)
      @resource_manager.should_receive(:get_song).with(:song2).and_return(song2)
      @sound_manager.play_song(:song2)
    end
    
  end
  
  describe "#unload" do
    
    it "halts sound playback when object is destroyed" do
      sound = mock('Sound', :play => nil, :playing => true)
      @resource_manager.should_receive(:get_sound).with(:boom).and_return(sound)
      @resource_manager.should_receive(:get_all_sounds).and_return([sound])
      @sound_manager.play_sound :boom
      sound.should_receive(:stop)
      @sound_manager.unload
    end
  
  end
    
end
