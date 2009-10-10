$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/managers').gsub('%20', ' ')
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/game_objects').gsub('%20', ' ')
#$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/states')
$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/input_helpers').gsub('%20', ' ')

# Because Windows isn't friendly with JRuby
$LOAD_PATH << 'managers'
$LOAD_PATH << 'game_objects'
#$LOAD_PATH << 'states'
$LOAD_PATH << 'input_helpers'

require 'file_system'
require 'platform'
require 'color'
require 'vector'
require 'spline'
require 'inflector'

require 'math'
require 'proc_enhancement'
require 'resource'
require 'game_object'
require 'message_queue'
require 'managers/input_manager'
require 'resource_manager'
require 'game_state'
require 'inflector'
require 'basic_game_object_manager'
require 'basic_update_manager'
require 'basic_render_manager'
require 'game'