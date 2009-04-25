module Gemini
  class InputMessage < Message
    attr_accessor :raw_input
    def initialize(name, data, raw_input)
      super(name, data)
      @raw_input = raw_input
    end
  end
end