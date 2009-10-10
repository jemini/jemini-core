#Tracks tags applied to objects.
class TagManager < Jemini::GameObject
  def load
    require 'behaviors/taggable'
    @tagged_objects = Hash.new { |h,k| h[k] = [] }
    listen_for(:after_add_game_object, game_state.manager(:game_object)) do |game_object|
      if game_object.kind_of? Taggable
        game_object.tags.each do |tag|
          @tagged_objects[tag] << game_object
        end
        listen_for(:tag_added, game_object) do |tag|
          @tagged_objects[tag] << game_object
        end
        listen_for(:tag_removed, game_object) do |tag|
          @tagged_objects[tag].delete game_object
        end
      end
    end
    
    listen_for(:after_remove_game_object, game_state.manager(:game_object)) do |game_object|
      if game_object.kind_of? Taggable
        game_object.tags.each do |tag|
          @tagged_objects[tag].delete game_object
        end
      end
    end
  end
  
  #Returns all game objects that have all the given tags.
  def find_by_all_tags(*tags)
    tags[1..-1].inject(@tagged_objects[tags[0]]) do |results, tag|
      results & @tagged_objects[tag]
    end
  end
  
  #Returns all game objects that have any of the given tags.
  def find_by_any_tags(*tags)
    tags.inject([]) do |results, tag|
      results.concat @tagged_objects[tag]
    end.uniq
  end
  
  #Returns all game objects that have the given tag.
  def find_by_tag(tag)
    @tagged_objects[tag]
  end
end