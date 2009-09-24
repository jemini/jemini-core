#$LOAD_PATH << File.expand_path('../jemini/src')
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../../src')
require 'jemini'
Jemini::Game.start_app("Gravitor", 1024, 768)