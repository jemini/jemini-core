module Gemini
  class BaseState
    def initialize
      
      load
    end
    
    def update(delta); end
    def render(graphics); end
  end
end