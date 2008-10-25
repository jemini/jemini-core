module Gemini
  class Math
    def self.degrees_to_radians(degrees)
      degrees * (::Math::PI/180)
    end

    def self.radians_to_degrees(radians)
      radians * (180/::Math::PI)
    end
  end
end