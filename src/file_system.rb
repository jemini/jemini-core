class File
  def self.in_jar?(path)
    path =~ /(\.jar!)|(^-$)/
  end

  def self.jar_of(path, jar_name=nil)
    base_dir_plus_jar = path.split('.jar!').first
    if jar_name
      dirs = base_dir_plus_jar.split('/')
      base_dir_plus_jar = (dirs[0..dirs.size - 2] + ['data']).join('/')
    end
#    jar_name = base_dir_plus_jar.split('/').last
#    jar_name + '.jar'
    base_dir_plus_jar.sub('file:', '') + '.jar'
  end

end