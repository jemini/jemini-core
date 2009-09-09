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

    describe 'global input' do
      before do
        # use the game_with_global_input for our game rather than 'game'
        $LOAD_PATH.delete $game_path
        @game_with_global_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'game_with_global_input'))
        $LOAD_PATH << @game_with_global_path
      end

      after do
        # put 'game' back
        $LOAD_PATH.delete @game_with_global_path
        $LOAD_PATH << $game_path
      end

      it 'automatically uses the input "global"' do
        class UsingGlobalState < Jemini::GameState
        end

        @game_state = UsingGlobalState.new(@container, @game)
        @game_state.manager(:input).listeners.should have(1).listener

      end
    end

    it 'ignores missing global input' do
      class MissingGlobalInputState < Jemini::GameState
      end

      lambda { @game_state = MissingGlobalInputState.new(@container, @game) }.should_not raise_error
    end

    it 'automatically uses the input named after the state' do
      class CrazyLevelState < Jemini::GameState
      end

      @game_state = CrazyLevelState.new(@container, @game)
      @game_state.manager(:input).listeners.should have(1).listener
    end

    it 'ignores missing input for implicit state inputs' do
      class MissingInputState < Jemini::GameState
      end

      lambda { @game_state = MissingInputState.new(@container, @game) }.should_not raise_error
    end

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