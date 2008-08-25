class TagManager < Gemini::GameObject
  def load
    require 'behaviors/taggable'
    @tagged_objects = Hash.new { |h,k| h[k] = [] }
    @game_state.manager(:game_object).on_after_add_game_object do |game_object|
      if game_object.kind_of? Taggable
        game_object.tags.each do |tag|
          @tagged_objects[tag] << game_object
        end
        game_object.on_tag_added do |tag|
          @tagged_objects[tag] << game_object
        end
        game_object.on_tag_removed do |tag|
          @tagged_objects[tag].delete game_object
        end
      end
    end
    
    @game_state.manager(:game_object).on_after_remove_game_object do |game_object|
      if game_object.kind_of? Taggable
        game_object.tags.each do |tag|
          @tagged_objects[tag].delete game_object
        end
      end
    end
  end
  
  def find_by_all_tags(*tags)
    tags[1..-1].inject(@tagged_objects[tags[0]]) do |results, tag|
      results & @tagged_objects[tag]
    end
  end
  
  def find_by_any_tags(*tags)
    tags.inject([]) do |results, tag|
      results.concat @tagged_objects[tag]
    end.uniq
  end
  
  def find_by_tag(tag)
    @tagged_objects[tag]
  end
end