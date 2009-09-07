require 'spec_helper'
require 'behaviors/audible'

describe 'Audible' do

  before :each do
    @sound_manager = mock('SoundManager')
    @state = mock('MockState', :manager => @sound_manager)
    @game_object = Jemini::GameObject.new(@state)
    @game_object.add_behavior :Audible
  end
  
  describe "#load_sound" do
    it "assigns a sound file to a key" do
      @sound_manager.should_receive(:add_sound)
      @game_object.load_sound :boom, "boom.wav"
    end
  end
  
  describe "#emit_sound" do
    it "accepts an assigned sound key" do
      @sound_manager.should_receive(:play_sound).with(:boom, 1.0, 1.0)
      @game_object.emit_sound :boom
    end
    it "accepts a volume" do
      @sound_manager.should_receive(:play_sound).with(:boom, 2.0, 1.0)
      @game_object.emit_sound :boom, 2.0
    end
    it "accepts a pitch" do
      @sound_manager.should_receive(:play_sound).with(:boom, 2.0, 3.0)
      @game_object.emit_sound :boom, 2.0, 3.0
    end
  end
  
end
