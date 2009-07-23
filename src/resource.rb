# TODO: Wrap in Gemini module
class Resource
  def self.path_of(file)
    class_loader = org.rubyforge.rawr.Main.java_class.class_loader
    if class_loader.find_resource("data/#{file}")
      "data/#{file}"
    else
      "../data/#{file}"
    end
  end
end