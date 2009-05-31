require 'rbconfig'

module Platform

  @@operating_system = Config::CONFIG['host_os']

  def using_unix?
    @using_unix ||= !using_windows?
  end

  def using_windows?
    @using_windows ||= (@@operating_system =~ /^win|mswin/i)
  end

  def using_linux?
    @using_linux ||= (@@operating_system =~ /linux/)
  end

  def using_osx?
    @using_osx ||= (@@operating_system =~ /darwin/)
  end

  def argument_delimiter
    using_windows? ? ';' : ':'
  end

  module_function :using_unix?, :using_windows?, :using_osx?, :argument_delimiter, :using_linux?
end