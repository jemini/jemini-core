class MultiAnimatedSprite < Gemini::Behavior
  depends_on :AnimatedSprite
  
  def load
    @animations = {}
  end
  
  def add_animation(options)
    name    = options[:name]
    sprites = options[:sprites]
    speed   = options[:speed]
    sprite_images = sprites.map do |sprite_image_name|
                      Java::org::newdawn::slick::Image.new sprite_image_name
                    end
    animation = Java::org::newdawn::slick::Animation.new(sprite_images.to_java(Java::org::newdawn::slick::Image), speed)
    @animations[name] = animation
  end
  
  def animate(animation_name)
    @target.animation = @animations[animation_name]
  end
end