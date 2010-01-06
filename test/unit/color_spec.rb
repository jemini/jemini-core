require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'color'

describe "Color" do
  it "accepts separate RGBA values within a 0.0-1.0 range" do
    color = Color.new(1.0, 0.5, 0.0, 1.0)

    color.red.should   be_close(1.0, 0.001)
    color.green.should be_close(0.5, 0.001)
    color.blue.should  be_close(0.0, 0.001)
    color.alpha.should be_close(1.0, 0.001)
  end

  it "accepts names for colors" do
    color = nil

    lambda { color = Color.new(:white) }.should_not raise_error

    color.red.should   be_close(1.0, 0.001)
    color.green.should be_close(1.0, 0.001)
    color.blue.should  be_close(1.0, 0.001)
    color.alpha.should be_close(1.0, 0.001)
  end

  it "accepts a single hex value for color 0xTRGB" do
    color = Color.new(0xFF0099)
    color.red.should   be_close(1.0, 0.001)
    color.green.should be_close(0.0, 0.001)
    color.blue.should  be_close(0.6, 0.001)
    color.alpha.should be_close(1.0, 0.001)
  end
end