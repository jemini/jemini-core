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
      MessageQueue.instance.post_message(:slick_input, [method, args])
    end
  end

  # Consumes raw slick_input events and output events based on 
  # registered key bindings.
  class InputManager
    include Singleton
    
    def setup(container, keymap)
      @keymap = {:key => {:down => Hash.new{|h,k| h[k] = []}, 
                          :up => Hash.new{|h,k| h[k] = []}, 
                          :pressed => Hash.new{|h,k| h[k] = []}}, 
                 :mouse => {:moved => Hash.new{|h,k| h[k] = []}}}
      begin
        keymap_contents = File.readlines(File.expand_path(File.dirname(__FILE__) + "/keymaps/#{keymap.underscore}.rb"))
      rescue Errno::ENOENT
        raise "Could not load keymap at #{File.expand_path(File.dirname(__FILE__) + "/keymaps/#{keymap.underscore}.rb")}"
      end
      instance_eval(keymap_contents.join)
      @raw_input = container.input
      @raw_input.add_listener Gemini::SlickInputListener.new
      MessageQueue.instance.add_listener(:slick_input, self) do |type, message|
        input_type = message[0]
        #puts "#{input_type} - #{message[1].inspect}"
        
        case input_type
        when :keyPressed
          if key_mappings = @keymap[:key][:down][message[1][0]]
            key_mappings.each do |key_map|
              MessageQueue.instance.post_message(key_map[0], key_map[1])
            end
          end
        when :keyReleased
          if key_mappings = @keymap[:key][:up][message[1][0]]
            key_mappings.each do |key_map|
              MessageQueue.instance.post_message(key_map[0], key_map[1])
            end
          end
        end
      end
    end
    
    def poll(screen_width, screen_height)
      @raw_input.poll(screen_width, screen_height)
    end
    
    def map(options, &block)
      case options[:source_type]
      when :key
        @keymap[options[:source_type]][options[:source_state]][options[:source_value]] << [options[:destination_type], options[:destination_value]]
      end
    end
  end
end