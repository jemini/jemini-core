require 'spec_helper'
require 'behaviors/metered'

describe 'Metered' do
  before :each do
    @game_object = Gemini::GameObject.new(@state)
    @game_object.add_behavior(:Metered)
  end
  describe '#on_before_meter_changes' do
    it 'accepts a meter key and block' do
      lambda {@game_object.on_before_meter_changes(:key) {}}.should_not raise_error
    end
    it 'throws an error without a block' do
      lambda {@game_object.on_before_meter_changes(:key)}.should raise_error
    end
    it 'throws an error without a key' do
      lambda {@game_object.on_before_meter_changes {}}.should raise_error
    end
    it 'calls the block with the new value before the meter changes' do
      @game_object.on_before_meter_changes(:health) {|value| update_bar(value)}
      @game_object.should_receive(:update_bar).with(10)
      @game_object.meter[:health] = 10
    end
    it 'can call the block without passing the new value' do
      @game_object.on_before_meter_changes(:health) {play_sound :beep}
      lambda {@game_object.meter[:health] = 10}.should_not raise_error
    end
    it 'does not update the value until after the block is called' do
      @game_object.meter[:health] = 11
      @game_object.on_before_meter_changes(:health) {|value| fail unless @game_object.meter[:health] == 11}
      @game_object.meter[:health] = 10
    end
    it 'can cause the meter not to be updated'
    it 'can alter the update value'
  end
  describe '#on_after_meter_changes' do
    it 'accepts a meter key and block' do
      lambda {@game_object.on_after_meter_changes(:key) {}}.should_not raise_error
    end
    it 'throws an error without a block' do
      lambda {@game_object.on_after_meter_changes(:key)}.should raise_error
    end
    it 'throws an error without a key' do
      lambda {@game_object.on_after_meter_changes {}}.should raise_error
    end
    it 'calls the block with the new value after the meter changes' do
      @game_object.on_after_meter_changes(:health) {|value| update_bar(value)}
      @game_object.should_receive(:update_bar).with(10)
      @game_object.meter[:health] = 10
    end
    it 'can call the block without passing the new value' do
      @game_object.on_after_meter_changes(:health) {play_sound :beep}
      lambda {@game_object.meter[:health] = 10}.should_not raise_error
    end
    it 'only calls the block after the value is updated' do
      @game_object.meter[:health] = 11
      @game_object.on_after_meter_changes(:health) {|value| fail unless @game_object.meter[:health] == 10}
      @game_object.meter[:health] = 10
    end
  end
  describe '#on_before_meter_increases'
  describe '#on_after_meter_increases'
  describe '#on_before_meter_decreases'
  describe '#on_after_meter_decreases'
  describe '#on_before_meter_empty'
  describe '#on_after_meter_empty'
  
end
