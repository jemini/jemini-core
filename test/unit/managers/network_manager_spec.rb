require 'spec_helper'
# require File.join(File.dirname(__FILE__), 'shared_spec')
require 'managers/network_manager'

describe 'NetworkManager' do

  # it_should_behave_like "a manager"

  before :each do
    @state = Jemini::GameState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @network_manager = Jemini::NetworkManager.new(@state)
    @state.send(:set_manager, :network, @network_manager)
  end
  
  it "accepts peer addresses" do
    @network_manager.add_peer '192.168.0.100', 9999
    @network_manager.peers.first.address.should == '192.168.0.100'
    @network_manager.peers.first.port.should == 9999
  end
  
  it "accepts a socket object"
  
  it "defaults to 5364 (JEMI) for port" do
    @network_manager.add_peer '192.168.0.100'
    @network_manager.peers.first.address.should == '192.168.0.100'
    @network_manager.peers.first.port.should == 5364
  end
  
  it "transmits events it receives to a peer" do
    pending
    @network_manager.add_peer 'localhost'
    @network_manager.handle_event :my_event, :notify_peers
    @network_manager.socket.should_receive(:send).with(:my_event, 0, 'localhost', 5364)
    @network_manager.notify(:my_event)
  end
  it "can broadcast an event to multiple peers"
  
  it "can be set as the authority (server)"
  it "overrides conflicting information from clients when it is the authority"
  it "can be set as a client"
  it "uses the authority's version of data when there is a conflict"

  it "can mark a request as guaranteed"
  it "re-sends guaranteed requests until a response is received"
  
end
