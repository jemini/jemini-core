$LOAD_PATH.clear
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../../src')
require 'gemini'
puts $LOAD_PATH
Gemini::Main.start_app("Life Tank", 800, 600, :MenuState)