require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/method_locator"

module Measurement
  class MPCMeasurer < Measurer
    def locator
      Locator::MethodLocator.new
    end

    def measurements_for(method)
      finder = MessageFinder.new
      finder.process(method.ast)

      total = finder.total_messages
      to_self = finder.messages_to_self
      to_ancestors = finder.messages_to_ancestors
      mpc = total - (to_self + to_ancestors)

      {
        total_messages_passed: total,
        messages_passed_to_self: to_self,
        messages_passed_to_ancestors: to_ancestors,
        mpc: mpc
      }
    end
  end

  class MessageFinder < Parser::AST::Processor
    attr_reader :total_messages, :messages_to_self, :messages_to_ancestors

    def initialize
      @total_messages, @messages_to_self, @messages_to_ancestors = 0, 0, 0
    end

    def on_send(ast)
      @total_messages += 1

      if ast.children.first.nil?
        @messages_to_self += 1
      elsif ast.children.first == :super
        @messages_to_ancestors += 1
      end

      super
    end
  end
end
