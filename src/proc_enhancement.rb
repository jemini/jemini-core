class Proc
  def source
     eval "self", binding   
  end
end