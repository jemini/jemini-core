$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/..")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../../src")
%w{behaviors game_objects keymaps managers states}.each do |dir|
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/#{dir}")
end

require 'gemini'
Gemini::Main.new("Test game", 640, 480)