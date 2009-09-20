require 'spec_helper'
require 'managers/sound_manager'

describe 'SoundManager' do

  before :each do
    @state = Jemini::BaseState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @sound_manager = SoundManager.new(@state)
    @state.send(:set_manager, :sound, @sound_manager)
    @resource_manager = mock('ResourceManager')
    @state.send(:set_manager, :resource, @resource_manager)
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
      song.should_receive(:play)
      song.should_receive(:volume=).with(0.5)
      @sound_manager.play_song(song, :volume => 0.5)
    end
    
    it "can loop songs" do
      song = mock('Music')
      song.should_receive(:loop)
      @sound_manager.play_song(song, :loop => true)
    end
    
    it "halts presently playing song if a new one is requested" do
      song = mock('Music')
      song.should_receive(:play)
      @sound_manager.play_song(song)
      song2 = mock('Music', :null_object => true)
      song.should_receive(:stop)
      @sound_manager.play_song(song2)
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
