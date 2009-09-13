require 'spec_helper'
require 'managers/sound_manager'

describe 'SoundManager' do

  # it_should_behave_like "a manager"

  before :each do
    @state = Jemini::BaseState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @sound_manager = SoundManager.new(@state)
    @state.send(:set_manager, :sound, @sound_manager)
  end
  
  it "caches sounds" do
    sound = mock('Sound')
    lambda {@sound_manager.add_sound :boom, sound}.should_not raise_error
  end
  
  it "plays back cached sounds" do
    sound = mock('Sound')
    @sound_manager.add_sound :boom, sound
    sound.should_receive(:play)
    @sound_manager.play_sound :boom
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
  
  it "halts sound playback when destroyed" do
    sound = mock('Sound', :play => nil, :playing => true)
    @sound_manager.add_sound :boom, sound
    @sound_manager.play_sound :boom
    sound.should_receive(:stop)
    @sound_manager.unload
  end
    
end
