module InstanceStubber
  def stub_instance(method)
    alias_method "stubbed___#{method}", method
    
    class_eval <<-METHOD
def #{method}(*args);end
    METHOD
  end

  def unstub_instance(method)
    alias_method method, "stubbed___#{method}"
  end
end

class Class
  include InstanceStubber
end