cd examples/tommyguns_and_booze
java -Djava.library.path=lib/native_files -Xmx1024m -XX:+UseConcMarkSweepGC -Djruby.compile.mode=FORCE -server -jar lib/jruby-complete.jar src/main.rb
