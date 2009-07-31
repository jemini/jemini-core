# TODO: Wrap in Gemini module
class Resource
  def self.path_of(file)
    #TODO: Find the JRuby classloader and use that?
    class_loader = org.newdawn.slick.geom.Vector2f.java_class.class_loader
    if class_loader.find_resource("data/#{file}")
      "data/#{file}"
    elsif File.exist?("../data/#{file}")
      "../data/#{file}"
    else
      "data/#{file}"
    end
  end
end