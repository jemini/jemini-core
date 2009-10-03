#A 2D sprite with mutltiple frames of animation.
class AnimatedImage < Jemini::Behavior
  DEFAULT_MILLISECONDS_PER_UPDATE = 500 # half a second
  java_import 'org.newdawn.slick.Image'
  java_import 'org.newdawn.slick.Animation'

  depends_on :Sprite
  depends_on :Updates
  
  attr_reader :animations
  
  def load
    @animations_per_action = {}
    @current_action = 'default'
    @animation_timer = 0
    @frame_number = 1
    @milliseconds_per_update = DEFAULT_MILLISECONDS_PER_UPDATE
    @target.on_update {|delta| update_animation(delta)}
  end

  def animate(action)
    self.current_action = action.to_s
  end

  def animate_as(noun)
    @noun = noun
    noun_regex = Regexp.new(noun.to_s)
    all_images_for_noun = @target.game_state.manager(:resource).image_names.select {|image| image.to_s =~ noun_regex }
    animations_for_noun = all_images_for_noun.map {|image_name| image_name.to_s.sub("#{@noun}_", '')}
    @animations = animations_for_noun.map {|animation| animation.sub(/\d/, '').to_sym}.uniq
    @animations.each do |action|
      action_regex = Regexp.new(action.to_s)
      animations = all_images_for_noun.select {|numbered_animation| numbered_animation.to_s =~ action_regex }
      @animations_per_action[action.to_s] = animations #.map {|a| a.to_s } 
    end
  end

private

  def current_action=(action)
    @animation_timer = 0
    @current_action = action
    @frame_number = 1 # one based
    @target.image = @animations_per_action[action.to_s].first
  end

  def update_animation(delta)
    return if @noun.nil?
    @animation_timer += delta
    return if @animation_timer < @milliseconds_per_update

    @frame_number += 1
    @animation_timer = 0

    animations = @animations_per_action[@current_action.to_s]
    @target.image = animations[@frame_number - 1]
  end
end