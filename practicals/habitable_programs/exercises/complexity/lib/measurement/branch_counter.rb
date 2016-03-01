require_relative "counter"

module Measurement
  class BranchCounter < Counter
    def on_send(node)
        if not node.children[0].nil? and not [:==, :!=, :<=, :>=, :<, :>.include?(node.children[1])
            increment
        end

        super(node)
    end
  end
end
