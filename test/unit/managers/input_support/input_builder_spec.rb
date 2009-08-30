require 'spec_helper'
#require 'managers/input_support/input_builder'

describe 'InputBuilder' do
  describe '.declare' do
    it 'allows mappings to be declared'
  end
  
  describe '#bind' do
    it 'allows bindings to be turned off with #off'
    it 'appends multiple bindings for the same action'
    it 'appends multiple bindings inside the same binding'
    it 'binds keyboard keys with the name of the key'
    it 'binds left, right, and middle mouse buttons'
    it 'binds scroll up and scroll down mouse buttons'
    it 'can bind to a given mouse button number'
    it 'can bind to a given xbox number'
  end

  describe '#axis_update' do
    it 'creates a binding that fires on every update with the new position of the axis'
    it 'works with joystick axes'
    it 'works with the mouse position'
  end

  describe '#release' do
    it 'creates a binding that fires when the button is released'
  end

  describe '#press' do
    it 'creates a binding that fires when the button is pressed'
  end

  describe '#hold' do
    it 'creates a binding that fires on each update while the button is held'
  end

  #TODO: Create a Chargable behavior that integrates with this binding type
  #      Charge will fire decorated events at the press and release of the charge
  #      Chargable will see these and know how to handle them.
  #      This is so we can play sounds and show graphics when a charge starts
  #      Or maybe we just have a matching pressed?
  describe '#charge' do
    it 'creates a binding that fires when the button is released'
    it 'uses a special event that measures the duration of the charge thus far'
    it 'auto releases after a given time if it is given with :auto_release (in seconds)'
    it 'stops charging the duration if :max is given (in seconds)'
  end

  describe 'modifier keys' do
    it 'fires if the modifier key is being held while the desired button is invoked'
    it 'can handle multiple modifier keys' # :shift_alt_tab
    it 'detects a modifier key only at the beginning of the binding name' # :alt_tab
  end

  describe 'binding sequences' do
    # let's hold off on this one for a while.
    it 'allows for sequential bindings with #and_then'
  end
end