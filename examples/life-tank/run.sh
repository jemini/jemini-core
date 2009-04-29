#! /bin/sh

jruby -J-Djava.library.path=../../lib/native_files -J-XX:+UseConcMarkSweepGC -J-Djruby.compile.mode=FORCE -J-server -J-Xms256m -J-Xmx512m src/main_with_classpath.rb