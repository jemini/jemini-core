require 'set'

#Indicates that the receiver has entered/exited an area.
class RegionalTransitionEvent
  attr_accessor :region, :spatial
  def initialize(region, spatial)
    @region = region
    @spatial = spatial
  end
end

#Makes an object receive a RegionalTransitionEvent whenever it enters/exits a given area.
class Regional < Jemini::Behavior
  depends_on :Spatial
  attr_accessor :dimensions, :region_shape
  alias_method :set_dimensions, :dimensions=
  alias_method :set_region_shape, :region_shape=
  
  # This is bad. We need a real collision system
  def load
    @game_object.enable_listeners_for :entered_region, :exited_region
    @game_object.move(0,0)
    @dimensions = Vector.new(1,1)
    @last_spatials_within = []
    @last_spatials_without = nil
    @last_spatials = []
    #TODO: SAVE: This should be turned on when requested.
#    game_state.manager(:update).on_update do
#      spatials = game_state.manager(:game_object).game_objects.select {|game_object| game_object.kind_of? Tangible}.compact
#      
#      spatials_within, spatials_without = spatials.partition {|spatial| within_region?(spatial)}
#      (spatials_within - @last_spatials_within).each do |spatial_within|
#        @game_object.notify :entered_region, RegionalTransitionEvent.new(self, spatial_within) if existed_last_update? spatial_within
#      end
#      @last_spatials_within = spatials_within
#      
#      unless @last_spatials_without.nil?
#        (spatials_without - @last_spatials_without).each do |spatial_without|
#          @game_object.notify :exited_region, RegionalTransitionEvent.new(self, spatial_without) if existed_last_update? spatial_without
#        end
#      end
#      @last_spatials_without = spatials_without
#      @last_spatials = spatials
#    end
  end
  
  #Indicates whether the given point is within the region's boundaries.
  def within_region?(spatial)
    half_width = dimensions.x / 2.0
    half_height = dimensions.y / 2.0
    ((@game_object.x - half_width) < spatial.x) && ((@game_object.x + half_width) > spatial.x) &&
    ((@game_object.y - half_height) < spatial.y) && ((@game_object.y + half_height) > spatial.y)
  end
  
  #Indicates whether the given object existed on the previous world update.
  #If not, it should not be considered for collision events on this update.
  def existed_last_update?(game_object)
    @last_spatials.find {|previous_game_object| game_object == previous_game_object}
  end

  def toggle_debug_mode
    @debug_mode = !@debug_mode
    if @debug_mode
      game_state.manager(:render).on_before_render do |graphics|
        old_color = graphics.color
        graphics.color = Color.new(0.0, 1.0, 0.0, 0.3).native_color
        half_width = dimensions.x / 2.0
        half_height = dimensions.y / 2.0
        graphics.fill_rect(@game_object.x - half_width, @game_object.y - half_height, dimensions.x, dimensions.y)
        graphics.color = old_color
      end
    else
      game_state.manager(:render).remove_before_draw self
    end
  end
end