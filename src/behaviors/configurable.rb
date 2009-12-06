#Allows an object to load attributes from a file.
class Configurable < Jemini::Behavior
  
  #The loaded configuration for the object.
  attr_reader :config

  #Loads a configuration with the given name.
  def configure_as(key)
    string = game_state.manager(:config).get_config(key)
    @config = parse(string)
  end
  
  private
  
    #Parse the config string, returning a hash of attributes.
    def parse(string)
      attributes = {}
      string.split("\n").each do |line|
        line.strip!
        next if line.empty?
        next if line =~ /^#/
        if line =~ /^([^=]+)=(.*)$/
          key = $1.strip.to_sym
          value = parse_value($2.strip)
          attributes[key] = value
        end
      end
      attributes
    end
    
    #Treats quoted strings as strings, unquoted numbers as numbers.
    def parse_value(value)
      case value
      when /^"(.*)"$/
        escape($1)
      when /^([\-\d]+)$/
        $1.to_i
      when /^([\-\d\.]+)$/
        $1.to_f
      else
        escape(value)
      end
    end
    
    def escape(string)
      string.gsub!(/\\\"/, '"')
      string.gsub!(/\\\\/, '\\')
      string
    end
  
end
