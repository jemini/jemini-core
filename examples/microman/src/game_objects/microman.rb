class Microman < Gemini::GameObject
  has_behavior :PlatformerControllable
  
  def load
    set_bounded_image "microman-standing.png"
    set_player_number 1
    add_animation :name => :stand, :speed => 500, :sprites => ["data/microman-standing.png"]
    add_animation :name => :walk,
                  :speed => 500,
                  :sprites => ["data/microman-walk0.png",
                               "data/microman-walk1.png",
                               "data/microman-walk2.png"]
    # TODO: Looks like we need a post load for behaviors
    animate :stand
  end
end