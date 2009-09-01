module Jemini
  module ListenableMixin
    def __added_listener_for(target, method_name, callback)
      @__methods_registered ||= {}
      @__methods_registered[target] = [method_name, callback]
    end
    
    def __remove_listeners
      return if @__methods_registered.nil?
      @__methods_registered.each do |target, listener_method_name_and_callback|
        target.send("remove_#{listener_method_name_and_callback.first}", self, listener_method_name_and_callback.last)
      end
    end
  end
end