class Pressable < Gemini::Behavior
  depends_on :Sprite
  depends_on :Clickable
  
  def load
    add_tag :button, :gui, :ui
  end
  
  def images=(image_path_hash)
    @normal_image = image_path_hash[:normal]
    @pressed_image = image_path_hash[:pressed]
  end
end