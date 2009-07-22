class Resource
  def self.path_of(file)
    if File.exist?("data/#{file}")
      "data/#{file}"
    else
      "../data/#{file}"
    end
  end
end