#! /bin/sh
cd src
java -Djruby.compile.mode=FORCE -Xms256m -Xmx512m -server -XX:+UseConcMarkSweepGC -Djava.library.path=../../../lib/native_files -jar ../../../lib/jruby-complete.jar main_with_classpath.rb
cd ..