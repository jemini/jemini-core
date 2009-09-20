# module LogMatcher
# 
#   class Log
# 
#     def initialize(message = nil)
#       @message = message
#     end
# 
#     def matches?(proc)
#       if @message != nil
#         if negative_expectation?
#           Jemini::GameObject.log.should_not_receive(:warn).with(@message)
#         else
#           Jemini::GameObject.log.should_receive(:warn).with(@message)
#         end
#       else
#         if negative_expectation?
#           Jemini::GameObject.log.should_not_receive(:warn)
#         else
#           Jemini::GameObject.log.should_receive(:warn)
#         end
#       end
#       proc.call
#     end
# 
#     def failure_message
#       @message ? "Did not receive warning '#{@message}'" : "Did not receive warning"
#     end
# 
#     def negative_failure_message
#       @message ? "Received warning '#{@message}'" : "Received warning"
#     end
# 
#     private
# 
#       def negative_expectation?
#         caller.first(3).find { |s| s =~ /should_not/ } #HACK: Lifted from RSpec raise_error matcher.
#       end
# 
#   end
#   
#   def log(message = nil)
#     LogMatcher::Log.new(message)
#   end
#   
# end
# 
# 
# Spec::Runner.configure do |config|
#   config.include LogMatcher
# end
