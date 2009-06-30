#Makes an object change appearance when clicked.
class Pressable < Gemini::Behavior
  depends_on :Sprite
  depends_on :Clickable
  
  def load
    add_tag :button, :gui, :ui
  end
  
  #Takes a hash with the following keys and values:
  #[:normal] The path for the image to display when the object is not pressed.
  #[:pressed] The path for the image to display when the object is pressed.
  def images=(image_path_hash)
    @normal_image = image_path_hash[:normal]
    @pressed_image = image_path_hash[:pressed]
  end
end