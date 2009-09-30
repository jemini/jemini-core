module Jemini
  class Resource
    @@base_path = '.'

    def self.path_of(file)
      #TODO: Find the JRuby classloader and use that?
      class_loader = org.newdawn.slick.geom.Vector2f.java_class.class_loader
      jarred_path = File.join(@@base_path, 'data', 'file')
      dev_path    = File.join(@@base_path, '..', 'data', 'file')
      if class_loader.find_resource(jarred_path)
        jarred_path
      elsif File.exist?(dev_path)
        dev_path
      else
        jarred_path
      end
    end
  end
end