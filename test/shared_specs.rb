describe "initial mock game", :shared => true do
  before :each do
    @game = mock(:MockGame)
  end
end

describe "initial mock container", :shared => true do
  before :each do
    @container = mock(:MockContainer)
  end
end

describe "initial mock state", :shared => true do
  it_should_behave_like 'initial mock container'
  
  before :each do
    @state = mock('MockState')
    @state.stub!(:name => 'mock')
    Jemini::GameState.active_state = @state
  end
end