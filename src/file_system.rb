class File
  def self.in_jar?(path)
    path =~ /^file:\/\//
  end
end