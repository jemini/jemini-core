class Tank < Gemini::GameObject
  has_behavior :Physical
  has_behavior :RecievesEvents

  def load
    handle_event :adjust_angle do |message|
      puts "adjusting angle by: #{message.value}"
    end

    handle_event :adjust_power do |power_delta|
      puts "adjusting power by: #{power_delta}"
    end

    handle_event :fire do
      puts "FIRE!"
    end
  end
end