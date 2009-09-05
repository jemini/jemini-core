class NetworkManager < Gemini::GameObject
  
  def load
    @peers = []
  end
  
  # def unload
  # end
  
  #Add an address and port to the list of network peers.
  def add_peer(address, port)
    @peers << [address, port]
  end
  
end