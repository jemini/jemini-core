require 'spec_helper'
require File.join(File.dirname(__FILE__), 'shared_spec')
require 'managers/network_manager'

describe 'NetworkManager' do

  it_should_behave_like "a manager"

  before :each do
    @network_manager = Gemini::NetworkManager.new(@state)
  end
  
  it "accepts peer addresses" do
    @network_manager.add_peer '192.168.0.100', 9999
    @network_manager.peers.should include(['192.168.0.100', 9999])
  end
  it "defaults to 5364 (JEMI) for port"
  it "can register itself as a listener for an event type"
  it "transmits events it receives to a peer"
  it "can broadcast an event to multiple peers"
  
  it "can be set as the authority (server)"
  it "overrides conflicting information from clients when it is the authority"
  it "can be set as a client"
  it "uses the authority's version of data when there is a conflict"

  it "can mark a request as guaranteed"
  it "re-sends guaranteed requests until a response is received"
  
end
