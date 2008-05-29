class InputManager
  def self.initialize(height)
    @@input = Input.new(height)
  end
  
  def self.input
    @@input
  end
  
  def self.poll(width, height)
    @@input.poll(width, height)
  end

  private
  def new; end
end