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
    sprite_images = sprites.map do |reference|
                      game_state.manager(:resource).get_image(reference)
                    end
    animation = Java::org::newdawn::slick::Animation.new(sprite_images.to_java(Java::org::newdawn::slick::Image), speed)
    @animations[name] = animation
  end
  
  def animate(animation_name)
    @game_object.animation = @animations[animation_name]
  end
end