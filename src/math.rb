module Gemini
  class Math
    SQUARE_ROOT_OF_TWO = ::Math::sqrt(2.0)

    def self.degrees_to_radians(degrees)
      degrees * (::Math::PI/180.0)
    end

    def self.radians_to_degrees(radians)
      radians * (180.0/::Math::PI)
    end
  end

  module FloatHelpers
    def near?(numeric, percent)
      self <= (numeric + numeric * percent) && self >= (numeric - numeric * percent)
    end
  end
end

class Float
  include Gemini::FloatHelpers
end