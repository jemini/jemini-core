#$LOAD_PATH << File.expand_path('../gemini/src')
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../../src')
require 'gemini'
Gemini::Main.start_app("Gravitor", 1024, 768)