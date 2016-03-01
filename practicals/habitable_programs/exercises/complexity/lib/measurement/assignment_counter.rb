require_relative "counter"

module Measurement
  class AssignmentCounter < Counter
    def on_ivasgn(node)
        increment
        super(node)
    end
    
    def on_lvasgn(node)
        increment
        super(node)
    end
    
    def on_cvasgn(node)
        increment
        super(node)
    end
  end
end
