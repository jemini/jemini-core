module Gemini
  class BehaviorEvent
    def initialize(*args)
      @memoizations = Hash.new { |h,k| h[k] = {} }
      load(*args)
    end
    
    def load(*args); end

    def self.method_added(name)
      match = /^memoize_(.+)$/.match name.to_s
      return unless match
      public_name = match[1]
      eval <<-ENDL
        def #{public_name}(*args)
          @memoizations[:#{public_name}][args] ||= #{name}
        end
      ENDL
    end
  end
end