module Gemini
  class SlickInputMessage < Message
    attr_accessor :event_name, :data

    def initialize(event_name, data)
      self.name = :slick_input
      @event_name = event_name
      @data = data
    end
  end
end