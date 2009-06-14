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
end