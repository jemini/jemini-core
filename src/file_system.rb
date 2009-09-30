class File
  def self.in_jar?(path)
    path =~ /(\.jar!)|(^-$)/
  end

  def self.jar_of(path)
    base_dir_plus_jar = path.split('.jar!').first
#    jar_name = base_dir_plus_jar.split('/').last
#    jar_name + '.jar'
    base_dir_plus_jar.sub('file:', '') + '.jar'
  end

end