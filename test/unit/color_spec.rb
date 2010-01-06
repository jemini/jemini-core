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

  it 'inverts alpha to show transparency' do
    color = Color.new(:white)
    color.alpha.should        be_close(1.0, 0.001)
    color.transparency.should be_close(0.0, 0.001)

    color.alpha = 0.5

    color.alpha.should        be_close(0.5, 0.001)
    color.transparency.should be_close(0.5, 0.001)

    color.alpha = 0.33

    color.alpha.should        be_close(0.33, 0.001)
    color.transparency.should be_close(0.67, 0.001)
  end

  it "can set alpha via transparency (inverted)" do
    color = Color.new(:white)
    color.alpha.should        be_close(1.0, 0.001)
    color.transparency.should be_close(0.0, 0.001)

    color.transparency = 0.5

    color.alpha.should        be_close(0.5, 0.001)
    color.transparency.should be_close(0.5, 0.001)

    color.transparency = 0.67

    color.alpha.should        be_close(0.33, 0.001)
    color.transparency.should be_close(0.67, 0.001)
  end

  it "can produce a new darkened color with a percent" do
    color = Color.new(:white)
    darker_color = color.darken_by 0.5

    color.red.should   be_close(1.0, 0.001)
    color.green.should be_close(1.0, 0.001)
    color.blue.should  be_close(1.0, 0.001)

    darker_color.red.should   be_close(0.5, 0.001)
    darker_color.green.should be_close(0.5, 0.001)
    darker_color.blue.should  be_close(0.5, 0.001)
  end

  it "can darken itself with a percent" do
    color = Color.new(:white)
    color.darken_by! 0.5

    color.red.should   be_close(0.5, 0.001)
    color.green.should be_close(0.5, 0.001)
    color.blue.should  be_close(0.5, 0.001)
  end

end