Jemini::InputBuilder.declare do |i|
  i.in_order_to :toggle_debug_mode do
    i.release :f1
  end

  i.in_order_to :quit do
    i.press :escape
  end
end