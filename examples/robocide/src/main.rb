$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../../src')
require 'jemini'
Jemini::Game.start_app("Robocide", 800, 600)