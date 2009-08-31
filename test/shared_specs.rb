describe "initial mock state", :shared => true do
  before :each do
    @state = mock('MockState')
    Gemini::BaseState.active_state = @state
  end
end