module Jemini
  
  class NetworkManager < Jemini::GameObject

    attr_accessor :socket

    class Peer
      attr_accessor :address, :port
      def initialize(address, port)
        @address, @port = address, port
      end
    end

    has_behavior :HandlesEvents

    #An array of all network peers.
    attr_accessor :peers

    def load
      @peers = []
      @socket = UDPSocket.new
    end

    # def unload
    # end

    #Add an address and port to the list of network peers.
    def add_peer(address, port = 5364)
      @peers << Peer.new(address, port)
    end

    #Send event to each registered peer.
    def notify_peers(event)
      @peers.each do |peer|
        @socket.send(event, 0, peer.address, peer.port)
      end
    end

  end

end