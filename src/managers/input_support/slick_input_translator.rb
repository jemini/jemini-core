module Jemini
  class SlickInputTranslator
    SLICK_INPUT_TYPE_TRANSLATION = {
      :keyPressed  => [:key, :pressed], # which key?
      :keyReleased => [:key, :released],
      :mouseMoved  => [:mouse, :moved],
      :mousePressed => [:mouse, :pressed], # which button?
      :mouseReleased => [:mouse, :released],
      :mouseClicked => [:mouse, :clicked],
      :mouseWheelMoved => [:mouse, :wheel_moved],
      :controllerLeftPressed => [:controller, :pressed]
      
    }
  end
end