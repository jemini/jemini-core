describe "initial mock state", :shared => true do
  before :each do
    @state = mock('MockState')
    Jemini::BaseState.active_state = @state
  end
end