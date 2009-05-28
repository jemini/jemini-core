include_class 'org.newdawn.slick.Input'
include_class 'org.newdawn.slick.InputListener'
require 'message_queue'

require 'input_support/input_mapping'
require 'input_support/input_message'
require 'input_support/slick_input_listener'
require 'input_support/slick_input_message'

KEY_PRESSED = {:source_type => :key, :source_state => :pressed}
KEY_RELEASED = {:source_type => :key, :source_state => :released}
KEY_HELD = {:source_type => :key, :source_state => :held}
MOUSE_MOVED = {:source_type => :mouse, :source_state => :moved, :source_value => :any}
MOUSE_BUTTON1_PRESSED = {:source_type => :mouse, :source_state => :pressed, :source_value => Input::MOUSE_LEFT_BUTTON }
MOUSE_BUTTON1_RELEASED = {:source_type => :mouse, :source_state => :released, :source_value => Input::MOUSE_LEFT_BUTTON}
MOUSE_BUTTON2_PRESSED = {:source_type => :mouse, :source_state => :pressed, :source_value => Input::MOUSE_RIGHT_BUTTON}
MOUSE_BUTTON2_RELEASED = {:source_type => :mouse, :source_state => :released, :source_value => Input::MOUSE_RIGHT_BUTTON}
MOUSE_BUTTON3_PRESSED = {:source_type => :mouse, :source_state => :pressed, :source_value => Input::MOUSE_MIDDLE_BUTTON}
MOUSE_BUTTON3_RELEASED = {:source_type => :mouse, :source_state => :released, :source_value => Input::MOUSE_MIDDLE_BUTTON}

#
# XBox 360 controllers use the following axii:
# x
# y
# z
# rx
# ry
# rz
#
# The 360 controller has two sticks and two triggers
#
CONTROLLER_AXIS_UPDATE = {:source_type => :controller, :source_state => :axis_update}
CONTROLLER_BUTTON_PRESSED = {:source_type => :controller, :source_state => :pressed}
CONTROLLER_BUTTON_RELEASED = {:source_type => :controller, :source_state => :released}
CONTROLLER_BUTTON_HELD = {:source_type => :controller, :source_state => :held}

XBOX_360_DPAD_UP            =  0
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
        Dir.glob(File.join(File.expand_path(path), "*.rb")).each do |input_helper_path|
          require input_helper_path
          include File.basename(input_helper_path, '.rb').camelize.constantize
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
      @keymap.values.map {|keymap_array| keymap_array.map{|keymap| keymap.poll(@raw_input)} }.flatten.compact.each do |game_message|
        @game_state.manager(:message_queue).post_message game_message
      end
      
      # Check for any held keys
#      @held_buttons.each do |device, button_ids|
#        button_ids.each do |button_id|
#          invoke_callbacks_for(device, :held, button_id, nil, delta)
#        end
#      end
    end

    # probably needs deletion
    def poll_keyboard
      
    end

    # probably needs deletion
    def poll_mouse

    end

    # probably needs deletion
    def poll_joystick
      @raw_input.controller_count.times do |controller_id|
        @raw_input.get_axis_count(controller_id).times do |axis_id|
          axis_name =  @raw_input.get_axis_name(controller_id, axis_id)
          axis_value = @raw_input.get_axis_value(controller_id, axis_id)
          # Do we really want to do this on each poll?
          # No raw slick event to catch, should be wrapped anyways
          message = InputMessage.new(:joystick_id => controller_id, :input_name => axis_name, :input_value => axis_value, :raw_input => @raw_input)
          invoke_callbacks_for(:joystick, :axis_update, axis_name, controller_id, message)
        end
      end
    end

    def connected_controller_size
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
  end
end