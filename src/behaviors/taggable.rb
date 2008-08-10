class Taggable < Gemini::Behavior
  declared_methods :add_tag, :remove_tag, :has_tag?
  attr_reader :tags

  def load
    @tags = []
    @target.enable_listeners_for :tag_added, :tag_removed
  end
  
  def add_tag(*tags)
    new_tags = tags - @tags
    @tags.concat new_tags
    new_tags.each { |tag| notify :tag_added, tag }  
  end
  
  def remove_tag(*tags)
    tags_to_remove = @tags & tags
    @tags -= tags_to_remove
    tags_to_remove.each {|tag| notify :tag_removed, tag}
  end
  
  def has_tag?(*tags)
    tags.inject(true) { |current, tag| current && @tags.member?(tag) }
  end
end