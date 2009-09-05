module Jemini
  
class NetworkManager < Jemini::GameObject
  
  #An array of [address, port] arrays for all network peers.
  attr_accessor :peers
  
  def load
    @peers = []
  end
  
  # def unload
  # end
  
  #Add an address and port to the list of network peers.
  def add_peer(address, port = 5364)
    @peers << [address, port]
  end
  
end

end