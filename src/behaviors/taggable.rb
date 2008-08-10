class Tags < Gemini::Behavior
  declared_methods :add_tag, :remove_tag, :has_tag?
  attr_reader :tags
  
  @@tagged_objects = Hash.new { |h,k| h[k] = [] }
  
  def self.find_by_all_tags(*tags)
    tags[1..-1].inject(@@tagged_objects[tags[0]]) do |results, tag|
      results & @@tagged_objects[tag]
    end
  end
  
  def self.find_by_any_tags(*tags)
    tags.inject([]) do |results, tag|
      results.concat @@tagged_objects[tag]
    end.uniq
  end
  
  def load
    @tags = []
  end
  
  def add_tag(*tags)
    @tags.concat tags
    tags.each do |tag|
      next if @@tagged_objects[tag].member? self
      @@tagged_objects[tag] << self
    end
  end
  
  def remove_tag(*tags)
    @tags -= tags
    tags.each do |tag|
      next if @@tagged_objects[tag].member? self
      @@tagged_objects[tag].delete self
    end
  end
  
  def has_tag?(*tags)
    tags.inject(true) { |current, tag| current && @tags.member?(tag) }
  end
end