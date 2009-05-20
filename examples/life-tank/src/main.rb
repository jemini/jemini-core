$profiling = false #change this to true to start the profiler
if $profiling
  require 'profile'
  Java::java::lang::Runtime.runtime.add_shutdown_hook(Java::java::lang::Thread.new do
    Profiler__::print_profile(STDERR) if $profiling
  end)
end

$LOAD_PATH.clear
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../../../src')
require 'gemini'
puts $LOAD_PATH
Gemini::Main.start_app("Life Tank", 800, 600, :MenuState, false)