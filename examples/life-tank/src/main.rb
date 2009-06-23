$profiling = false #change this to true to start the profiler
if $profiling
  require 'profile'
  Java::java::lang::Runtime.runtime.add_shutdown_hook(Java::java::lang::Thread.new do
    Profiler__::print_profile(STDERR) if $profiling
  end)
end

require 'java'

$LOAD_PATH.clear
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

# only when running in non-standalone
if File.exist? File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lib'))
  jar_glob = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', '*.jar'))
  Dir.glob(jar_glob).each do |jar|
    $CLASSPATH << jar
  end
end
if File.exist? File.join(File.dirname(__FILE__), '..', '..', '..', 'src')
  $LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', '..', 'src')
end
%w{behaviors game_objects keymaps managers states}.each do |dir|
  $LOAD_PATH << "src/#{dir}"
end

require 'gemini'

begin
  # Change :HelloState to point to the initial state of your game
  # Gemini::Main.start_app("", 800, 600, :HelloWorldState, false)
  Gemini::Main.start_app("Life Tank", 800, 600, :MenuState, false)
rescue => e
  warn e
  warn e.backtrace
end
