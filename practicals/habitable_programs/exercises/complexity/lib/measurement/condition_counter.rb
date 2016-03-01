require_relative "counter"

module Measurement
  class ConditionCounter < Counter
    def on_send(node)
        # Conditional operators
        if [:==, :!=, :<=, :>=, :<, :>].include?(node.children[1])
            increment
        end
    
        super(node)
    end
    
    def on_or(node)
        increment
        super(node)
    end
    
    def on_and(node)
        increment
        super(node)
    end
    
    def on_if(node)
        # Only if it has a else
        if not node.children[2].nil?
            increment
        end
        
        super(node)
    end
    
    def on_when(node)
        increment
        super(node)
    end
    
    def on_case(node)
        # Send in case is "else"
        node.children.each do |n|
            if n.type == :send
                increment
            end 
        end
        
        super(node)
    end
    
    def on_rescue(node)
        increment
        super(node)
    end
  end
end
