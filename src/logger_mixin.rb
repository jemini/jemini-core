require 'logger'

module LoggerMixin

  #Get the Logger object (see the Ruby standard library documentation).
  #The log level is set to match the LOG_LEVEL environment variable, or Logger::ERROR by default.
  def log
    @log ||= Logger.new(STDOUT)
    @log.level = (ENV['LOG_LEVEL'] and "Logger::#{ENV['LOG_LEVEL']}".constantize) || Logger::ERROR
    @log
  end
  
end