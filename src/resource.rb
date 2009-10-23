module Jemini
  class Resource
    puts "+++++++++++++++++++"
    puts $0
    puts "In jar? #{File.in_jar?($0)}"
    puts "+++++++++++++++++++"
    # go up two dirs from lib/java
    @@base_path = File.in_jar?($0) ? File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'data.jar!', 'data')) : 'data'

    def self.base_path
      @@base_path
    end

    def self.path_of(file)
      #TODO: Find the JRuby classloader and use that?
      class_loader = org.newdawn.slick.geom.Vector2f.java_class.class_loader
      jarred_path  = file
      dev_path     = File.join('..', file)

#      log.debug "jarred path: #{jarred_path}"
#      log.debug "dev path: #{dev_path}"
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