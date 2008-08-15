include_class 'org.newdawn.slick.Input'
include_class 'org.newdawn.slick.InputListener'
require 'message_queue'
require 'singleton'

module Gemini
  class SlickInputListener
    include InputListener

    def isAcceptingInput
      true
    end

    def method_missing(method, *args)
      return if method == :inputEnded
      MessageQueue.instance.post_message(Message.new(:slick_input, [method, args]))
    end
  end

  # Consumes raw slick_input events and output events based on 
  # registered key bindings.
  class InputManager
    include Singleton
    
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
    
    def setup(container, keymap)
      @keymap = {:key => {:pressed => Hash.new{|h,k| h[k] = []}, 
                          :released => Hash.new{|h,k| h[k] = []},
                          :held => Hash.new{|h,k| h[k] = []}}, 
                 :mouse => {:moved => Hash.new{|h,k| h[k] = []},
                            :pressed => Hash.new{|h,k| h[k] = []},
                            :released => Hash.new{|h,k| h[k] = []},
                            :clicked => Hash.new{|h,k| h[k] = []},
                            :wheel_moved => Hash.new{|h,k| h[k] = []}}
                }
      @held_keys = []
      keymap_name = "/keymaps/#{keymap.underscore}.rb"
      keymap_path = $LOAD_PATH.find do |path|
        File.exist? path + keymap_name
      end

      raise "Could not find keymap: #{keymap_name} on load path" if keymap_path.nil?
      keymap_contents = IO.read(keymap_path + keymap_name)

      instance_eval(keymap_contents)
      @raw_input = container.input
      @raw_input.add_listener Gemini::SlickInputListener.new
      MessageQueue.instance.add_listener(:slick_input, self) do |message|
        value = message.value[1][0]
        case message.value[0]
        when :keyPressed
          type = :key
          action = :pressed
          @held_keys << value
        when :keyReleased
          type = :key
          action = :released
          @held_keys.delete value
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
        end
        
        next if type.nil? or action.nil?

        invoke_callbacks_for(type, action, value)
      end
    end
    
    def poll(screen_width, screen_height)
      @raw_input.poll(screen_width, screen_height)
      
      # Check for any held keys
      @held_keys.each do |key_id|
        invoke_callbacks_for(:key, :held, key_id)
      end
    end
    
    def map(options, options2=nil, &block)
      if options && options2
        options.merge! options2
      end
      @keymap[options[:source_type]][options[:source_state]][options[:source_value]] << [options[:destination_type], options[:destination_value], block]
    end
    
  private
    def invoke_callbacks_for(type, action, value)
      key_mappings = @keymap[type][action][value]
      unless key_mappings.empty?
        key_mappings.each do |key_map|
          message_to_post = Message.new(key_map[0], key_map[1])
          if key_map[2] #block param
            key_map[2].call(message.value[1], message_to_post)
          end
          MessageQueue.instance.post_message(message_to_post)
        end
      end
    end
  end
end