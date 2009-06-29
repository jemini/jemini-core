#A 2D sprite with mutltiple frames of animation.
class AnimatedSprite < Gemini::Behavior
  include_class 'org.newdawn.slick.Image'
  include_class 'org.newdawn.slick.Animation'
  depends_on :Sprite
  attr_accessor :animation
  
  def load
    @fps = 1
    @animation = Animation.new
    @target.game_state.manager(:update).on_before_update do |delta|
      unless @animation.nil?
        @animation.update(delta)
        begin
          @target.set_image @animation.current_frame
        rescue; end #deliberately swallow
      end
    end
    @mode = :normal
  end

  #Takes one or more Images or names of files in the data directory to add to the animation.
  def sprites(*sprite_names)
    sprite_names.each do |sprite_name|
      if sprite_name.kind_of? Image
        @animation.add_frame(sprite_name, 1000)
      else
        @animation.add_frame(Image.new("data/#{sprite_name}"), 1000)
      end
    end
    @target.set_image @animation.current_frame
  end
  alias_method :set_sprites, :sprites

  #Sets frames per second for the animation.
  def animation_fps(fps)
    @fps = fps
    (0...@animation.frame_count).each {|i| @animation.set_duration(i, 1000.0/@fps)}
  end
  
  #Sets animation mode.  Possible values are :normal, :looping, or :ping_pong.
  def animation_mode(mode)
    case mode
    when :normal
      @animation.looping = false
      @animation.ping_pong = false
    when :looping
      @animation.looping = true
      @animation.ping_pong = false
    when :ping_pong
      @animation.looping = true
      @animation.ping_pong = true
    end
  end
end