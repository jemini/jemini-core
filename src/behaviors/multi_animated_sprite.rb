#Gives an object multiple animations it can switch between.
class MultiAnimatedSprite < Jemini::Behavior
  depends_on :AnimatedSprite
  
  def load
    @animations = {}
  end

  #Add an animation for later use.
  #Takes a hash with the following keys and values:
  #[:name] The name to assign the animation.
  #[:sprites] A list of Image names.
  #[:speed] The speed at which to animate.
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