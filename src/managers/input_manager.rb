include_class 'org.newdawn.slick.Input'
include_class 'org.newdawn.slick.InputListener'
require 'message_queue'

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
CONTROLLER0_PRESSED = {:source_type => :controller0, :source_state => :pressed}
CONTROLLER0_RELEASED = {:source_type => :controller0, :source_state => :released}
CONTROLLER0_HELD = {:source_type => :controller0, :source_state => :held}
CONTROLLER1_PRESSED = {:source_type => :controller1, :source_state => :pressed}
CONTROLLER1_RELEASED = {:source_type => :controller1, :source_state => :released}
CONTROLLER1_HELD = {:source_type => :controller1, :source_state => :held}
CONTROLLER2_PRESSED = {:source_type => :controller2, :source_state => :pressed}
CONTROLLER2_RELEASED = {:source_type => :controller2, :source_state => :released}
CONTROLLER2_HELD = {:source_type => :controller2, :source_state => :held}
CONTROLLER3_PRESSED = {:source_type => :controller3, :source_state => :pressed}
CONTROLLER3_RELEASED = {:source_type => :controller3, :source_state => :released}
CONTROLLER3_HELD = {:source_type => :controller3, :source_state => :held}
CONTROLLER4_PRESSED = {:source_type => :controller4, :source_state => :pressed}
CONTROLLER4_RELEASED = {:source_type => :controller4, :source_state => :released}
CONTROLLER4_HELD = {:source_type => :controller4, :source_state => :held}
CONTROLLER5_PRESSED = {:source_type => :controller5, :source_state => :pressed}
CONTROLLER5_RELEASED = {:source_type => :controller5, :source_state => :released}
CONTROLLER5_HELD = {:source_type => :controller5, :source_state => :held}

LEFT_BUTTON = -1
RIGHT_BUTTON = -2
UP_BUTTON = -3
DOWN_BUTTON = -4

class MouseEvent
  PRESSED = :pressed
  RELEASED = :released
  attr_accessor :state, :location
  def initialize(state, location)
    @state, @location = state, location
  end
end

module Gemini
  class SlickInputListener
    include InputListener
    attr_accessor :delta
    
    def initialize(state)
      @state = state
    end
    
    def isAcceptingInput
      #@state == BaseState.active_state
      true
    end

    def method_missing(method, *args)
      return if (method == :inputEnded) || @state != BaseState.active_state
      @state.manager(:message_queue).post_message(Message.new(:slick_input, [method, args], @delta))
    end
  end

  # Consumes raw slick_input events and output events based on 
  # registered key bindings.
  class InputManager < Gemini::GameObject
    
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
      @keymap = {:key => {:pressed => Hash.new{|h,k| h[k] = []}, 
                          :released => Hash.new{|h,k| h[k] = []},
                          :held => Hash.new{|h,k| h[k] = []}}, 
                 :mouse => {:moved => Hash.new{|h,k| h[k] = []},
                            :pressed => Hash.new{|h,k| h[k] = []},
                            :released => Hash.new{|h,k| h[k] = []},
                            :clicked => Hash.new{|h,k| h[k] = []},
                            :wheel_moved => Hash.new{|h,k| h[k] = []}}
                }
      (0..(MAX_CONTROLLERS - 1)).each do |controller_id|
        @keymap["controller#{controller_id}".to_sym] = {
          :pressed => Hash.new{|h,k| h[k] = []},
          :released => Hash.new{|h,k| h[k] = []},
          :held => Hash.new{|h,k| h[k] = []},
        }
      end

      @held_buttons = Hash.new {|h,k| h[k] = []}
      keymap_name = "/keymaps/#{keymap.underscore}"
#      puts $LOAD_PATH
      keymap_path = $LOAD_PATH.find do |path|
        puts "trying path for .rb/.class: #{File.expand_path(path + keymap_name)}"
        File.exist?(File.expand_path(path + keymap_name + '.rb')) || File.exist?(File.expand_path(path + keymap_name + '.class'))
      end
      puts "keymap found: #{keymap_path.inspect}"
#
#      raise "Could not find keymap: #{keymap_name} on load path" if keymap_path.nil?
#      keymap_contents = begin
#                          IO.read(keymap_path + keymap_name + '.rb')
#                        rescue
#                          IO.read(keymap_path + keymap_name + '.class')
#                        end
#      instance_eval(keymap_contents)
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
      @game_state.manager(:message_queue).add_listener(:slick_input, self) do |message|
        value = message.value[1][0]
        case message.value[0]
        when :keyPressed
          type = :key
          action = :pressed
          @held_buttons[:key] << value
        when :keyReleased
          type = :key
          action = :released
          @held_buttons[:key].delete value
        when :mouseMoved
          type = :mouse
          action = :moved
          value = :any
        when :mousePressed
          type = :mouse
          action = :pressed
        when :mouseReleased
          type = :mouse
          action = :released
        when :mouseClicked
          type = :mouse
          action = :clicked
        when :mouseWheelMoved
          type = :mouse
          action = :wheel_moved
        when :controllerLeftPressed
          type = "controller#{value}".to_sym
          action = :pressed
          value = LEFT_BUTTON
          @held_buttons[type] << value
        when :controllerRightPressed
          type = "controller#{value}".to_sym
          action = :pressed
          value = RIGHT_BUTTON
          @held_buttons[type] << value
        when :controllerUpPressed
          type = "controller#{value}".to_sym
          action = :pressed
          value = UP_BUTTON
          @held_buttons[type] << value
        when :controllerDownPressed
          type = "controller#{value}".to_sym
          action = :pressed
          value = DOWN_BUTTON
          @held_buttons[type] << value
        when :controllerLeftReleased
          type = "controller#{value}".to_sym
          action = :released
          value = LEFT_BUTTON
          @held_buttons[type].delete value
        when :controllerRightReleased
          type = "controller#{value}".to_sym
          action = :released
          value = RIGHT_BUTTON
          @held_buttons[type].delete value
        when :controllerUpReleased
          type = "controller#{value}".to_sym
          action = :released
          value = UP_BUTTON
          @held_buttons[type].delete value
        when :controllerDownReleased
          type = "controller#{value}".to_sym
          action = :released
          value = DOWN_BUTTON
          @held_buttons[type].delete value
        when :controllerButtonPressed
          type = "controller#{value}".to_sym
          action = :pressed
          value = message.value[1][1]
          @held_buttons[type] << value
        when :controllerButtonReleased
          type = "controller#{value}".to_sym
          action = :released
          value = message.value[1][1]
          @held_buttons[type].delete value
        end
        
        next if type.nil? or action.nil?

        invoke_callbacks_for(type, action, value, message, message.delta)
      end
    end
    
    def poll(screen_width, screen_height, delta)
      @input_listener.delta = delta
      @raw_input.poll(screen_width, screen_height)
      
      # Check for any held keys
      @held_buttons.each do |device, button_ids|
        button_ids.each do |button_id|
          invoke_callbacks_for(device, :held, button_id, nil, delta)
        end
      end
    end
    
    def map(options, options2=nil, &block)
      if options && options2
        options.merge! options2
      end
      @keymap[options[:source_type]][options[:source_state]][options[:source_value]] << [options[:destination_type], options[:destination_value], block]
    end
    
  private
    def invoke_callbacks_for(type, action, value, message, delta)
      key_mappings = @keymap[type][action][value]
      unless key_mappings.empty?
        key_mappings.each do |key_map|
          message_to_post = Message.new(key_map[0], key_map[1], delta)
          if key_map[2] #block param
            key_map[2].call(message.value[1], message_to_post)
          end
          @game_state.manager(:message_queue).post_message(message_to_post)
        end
      end
    end
  end
end