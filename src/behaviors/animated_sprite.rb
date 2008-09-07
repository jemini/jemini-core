class AnimatedSprite < Gemini::Behavior
  include_class 'org.newdawn.slick.Image'
  include_class 'org.newdawn.slick.Animation'
  depends_on :Spatial2d
  declared_methods :draw, :sprites, :animation_fps, :animation_mode, :animation, :animation=
  attr_accessor :animation
  
  def load
    @fps = 1
    @animation = Animation.new
    game_state.manager(:update).on_before_update do |delta|
      @animation.update(delta) unless @animation.nil?
    end
    @mode = :normal
  end
  
  def sprites(*sprite_names)
    sprite_names.each {|sprite_name| @animation.add_frame(Image.new("data/#{sprite_name}"), 1000)}
    self.width = @animation.current_frame.width
    self.height = @animation.current_frame.height
  end
  
  def animation_fps(fps)
    @fps = fps
    (0...@animation.frame_count).each {|i| @animation.set_duration(i, 1000.0/@fps)}
  end
  
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
  
  def draw(graphics)
    @animation.draw(x, y) unless @animation.nil?
  end
end