$LOAD_PATH << File.expand_path('../gemini/src')
$LOAD_PATH << 'src'
require 'gemini'
Gemini::Main.start_app("Gravitor", 1024, 768)