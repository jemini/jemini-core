java_import 'org.newdawn.slick.Input'

require 'message_queue'

require 'managers/input_support/input_mapping'
require 'managers/input_support/mouse_mapping'
require 'managers/input_support/key_mapping'
require 'managers/input_support/joystick_mapping'

require 'managers/input_support/input_message'
require 'managers/input_support/slick_input_listener'
require 'managers/input_support/slick_input_message'

#TODO: Discover Windows mappings
if Platform.using_osx?
  # buttons
  XBOX_360_DPAD_UP            =  0 # No Windows "buttons" for the dpad - it's unusable
  XBOX_360_DPAD_DOWN          =  1
  XBOX_360_DPAD_LEFT          =  2
  XBOX_360_DPAD_RIGHT         =  3
  XBOX_360_START              =  4
  XBOX_360_BACK               =  5
  XBOX_360_LEFT_STICK         =  6
  XBOX_360_RIGHT_STICK        =  7
  XBOX_360_LEFT_BUMPER        =  8
  XBOX_360_RIGHT_BUMPER       =  9
  XBOX_360_GUIDE_BUTTON       = 10
  XBOX_360_A                  = 11
  XBOX_360_B                  = 12
  XBOX_360_X                  = 13
  XBOX_360_Y                  = 14
  # axes
  XBOX_360_LEFT_X_AXIS        = 'x'
  XBOX_360_LEFT_Y_AXIS        = 'y'
  XBOX_360_LEFT_TRIGGER_AXIS  = 'z'  # On Windows, both triggers serve as one axis
  XBOX_360_RIGHT_X_AXIS       = 'rx'
  XBOX_360_RIGHT_Y_AXIS       = 'ry'
  XBOX_360_RIGHT_TRIGGER_AXIS = 'rz' # On Windows, both triggers serve as one axis
elsif Platform.using_windows?
  # buttons
  XBOX_360_A                  =  0
  XBOX_360_B                  =  1
  XBOX_360_X                  =  2
  XBOX_360_Y                  =  3
  XBOX_360_LEFT_BUMPER        =  4
  XBOX_360_RIGHT_BUMPER       =  5
  XBOX_360_BACK               =  6
  XBOX_360_START              =  7
  XBOX_360_LEFT_STICK         =  8
  XBOX_360_RIGHT_STICK        =  9
  #axes
  XBOX_360_LEFT_X_AXIS        = 'X Axis'
  XBOX_360_LEFT_Y_AXIS        = 'Y Axis'
  XBOX_360_TRIGGER_AXIS       = 'Z Axis'  # On OSX, both triggers serve as individual axes
  XBOX_360_RIGHT_X_AXIS       = 'X Rotation'
  XBOX_360_RIGHT_Y_AXIS       = 'Y Rotation'
end

# LWJGL can't poll for buttons in the negative range yet. Possible bug to report?
# 360 controller provides button presses for analog inputs for convienence
XBOX_360_LEFT_STICK_LEFT = -1
XBOX_360_LEFT_STICK_RIGHT = -2
XBOX_360_LEFT_STICK_UP = -3
XBOX_360_LEFT_STICK_DOWN = -4

class MouseEvent
  PRESSED = :pressed
  RELEASED = :released
  attr_accessor :state, :location
  def initialize(state, location)
    @state, @location = state, location
  end
end

module Gemini
  # Consumes raw slick_input events and output events based on 
  # registered key bindings.
  class InputManager < Gemini::GameObject
    
    $LOAD_PATH.each do |path|
      if File.basename(path) == "input_helpers"
        # could be .class or .rb, we'll just search for *.* and hope nobody is silly (:
        Dir.glob(File.join(File.expand_path(path), "*.*").gsub('%20', ' ')).each do |input_helper_path|
          require input_helper_path.sub('.class', '') # .class can't be required directly
          include File.basename(input_helper_path, '.rb').sub('.class', '').camelize.constantize
        end
      end
    end

    MAX_CONTROLLERS = 6
    
    @@loading_input_manager = nil
    def self.loading_input_manager
      @@loading_input_manager
    end

    def self.define_keymap
      yield loading_input_manager
    end

    def load(container)
      @held_keys = []
      @raw_input = container.input
      @input_listener = Gemini::SlickInputListener.new(@game_state)
      @raw_input.add_listener @input_listener
      @held_buttons = {}
    end
    
    def load_keymap(keymap)
      @keymap = Hash.new{|h,k| h[k] = []}

      @held_buttons = Hash.new {|h,k| h[k] = []}
      keymap_name = "/keymaps/#{keymap.underscore}"
      keymap_path = $LOAD_PATH.find do |path|
        puts "trying path for .rb/.class: #{File.expand_path(path + keymap_name)}"
        File.exist?(File.expand_path(path + keymap_name + '.rb')) || File.exist?(File.expand_path(path + keymap_name + '.class'))
      end
      puts "keymap found: #{keymap_path.inspect}"

      @@loading_input_manager = self
      keymap_path += '/' unless keymap_path.nil? # was using <<, but that alters the load path in a bad way.
      begin
        # the method 'load' already exists on this scope
        Kernel.load "#{keymap_path}#{keymap_name.sub('/', '')}.class"
      rescue LoadError
        # the method 'load' already exists on this scope
        Kernel.load "#{keymap_path}#{keymap_name.sub('/', '')}.rb"
      end
      @@loading_input_manager = nil
    end
    
    def poll(screen_width, screen_height, delta)
      return if @keymap.nil?
      @input_listener.delta = delta
      @raw_input.poll(screen_width, screen_height)
      all_keymappings_to_game_messages.each do |game_message|
        @game_state.manager(:message_queue).post_message game_message
      end
    end

    def connected_joystick_size
      @raw_input.controller_count
    end

    def map_key(options, &block)
      map :key, options, &block
    end

    def map_mouse(options, &block)
      map :mouse, options, &block
    end

    def map_joystick(options, &block)
      map :joystick, options, &block
    end
    
  private
    def find_keymaps_for(device, input_button_or_axis, id)
      @keymap["#{device}_#{input_button_or_axis}_#{id}"]
    end

    def map(device, options, &block)
      mapping = InputMapping.create(device, options, &block)
      @keymap[mapping.key] << mapping
    end

    def invoke_callbacks_for(device, input_type, input_button_or_axis, id, input_message)
      key_mappings = find_keymaps_for(device, input_type, input_button_or_axis, id)
      key_mappings.each do |key_map|
        @game_state.manager(:message_queue).post_message key_map.to_game_message(input_message)
      end
    end

    def all_keymappings_to_game_messages
      @keymap.values.map {|keymap_array| poll_to_game_messages(keymap_array)}.flatten.compact
    end

    def poll_to_game_messages(keymaps)
      messages = []
      keymaps.reject! do |keymap|
        begin
          messages << keymap.poll(@raw_input)
          false  # don't delete me
        rescue => e
          warn "error in poll: #{e}"
          warn "removing keymap #{keymap}"
          true   # I've been bad, delete me
        end
      end
      messages
    end
  end
end