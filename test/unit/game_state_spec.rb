require 'game_state'

describe 'Jemini::GameState' do
  it_should_behave_like 'initial mock game'
  it_should_behave_like 'initial mock container'

  before :each do
    @raw_input = mock(:MockContainerInput, :add_listener => nil, :poll => nil)
    @container.stub!(:input).and_return @raw_input
    @game_state = Jemini::GameState.new(@container, @game)
    Jemini::GameState.active_state = @game_state
  end

  describe 'input' do
    it 'allows adding of inputs with .input' do
      class InputState < Jemini::GameState
        use_input :jump
      end

      @game_state = InputState.new(@container, @game)
      @game_state.manager(:input).listeners.should have(1).listener
    end

    it 'automatically uses the input "global"'
    it 'automatically uses the input named after the state'

    it 'can dynamically load input with #use_input' do
      @game_state.use_input :jump
      @game_state.manager(:input).listeners.should have(1).listener
    end

    it 'can dynamically reload inputs with #use_input' do
      @game_state.use_input :jump
      @game_state.use_input :jump
      @game_state.manager(:input).listeners.should have(2).listeners
    end
  end
end