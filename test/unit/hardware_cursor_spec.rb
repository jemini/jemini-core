require 'spec_helper'
require 'managers/render_support/hardware_cursor'

describe "HardwareCursor" do
  it_should_behave_like 'test state'
  
  before :each do

    @mock_render_manager = mock('mock render manager', :game_state => @game_state)
    @mock_render_manager.extend HardwareCursor
  end

  describe "Slick integration" do
    it 'loads :mouse_cursor as an image resource for a static cursor' do
      stub_image_resource(:mouse_cursor)
      @container.should_receive(:set_mouse_cursor)
      @game_state.manager(:resource).send(:notify, :resources_loaded)
    end

    it "does nothing to the hardware cursor if the resource cannot be loaded" do
      lambda {@mock_render_manager.use_available_hardware_cursor}.should_not raise_error
    end

    it 'loads :mouse_cursor(1..n) for animated cursors'

    it 'reverts to the default cursor when the render manager is torn down' do
      @container.should_receive(:set_default_mouse_cursor)
      @mock_render_manager.revert_hardware_cursor
    end
  end

  describe "as used in the render manager" do
    it 'loads the :mouse_cursor as an image resource for a static cursor' do
      stub_image_resource(:mouse_cursor)
      @container.should_receive(:set_mouse_cursor)
      @game_state.manager(:resource).send(:notify, :resources_loaded)
    end

    it "does nothing to the hardware cursor if the resource cannot be loaded" do
      @container.should_not_receive(:set_mouse_cursor)
      lambda {@game_state.create :basic_render_manager }.should_not raise_error
    end

    it 'reverts to the default cursor when the render manager is torn down' do
      stub_image_resource(:mouse_cursor)
      @container.stub!(:set_mouse_cursor)
      @container.should_receive(:set_default_mouse_cursor)

      manager = @game_state.create :basic_render_manager

      @game_state.remove manager
    end
  end
end