require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/method_locator"

module Measurement
  class MethodCounter < Parser::AST::Processor
    attr_reader :n_parameters

    def initialize
      @n_parameters = 0
    end

    def on_arg(node)
      super(node)
      @n_parameters += 1
    end

    def on_restarg(node)
      super(node)
      @n_parameters += 1
    end

    def on_optarg(node)
      super(node)
      @n_parameters += 1
    end

    def on_blockarg(node)
      super(node)
      @n_parameters += 1
    end
  end

  class MethodMeasurer < Measurer
    def locator
      Locator::MethodLocator.new
    end

    def measurements_for(method)
      {
        lines_of_code: count_lines_of_code(method),
        number_of_parameters: count_parameters(method)
      }
    end

    def count_lines_of_code(method)
      method.source.lines.to_a.select { |s| not s.strip.empty? }.size
    end

    def count_parameters(method)
      counter = MethodCounter.new
      counter.process(method.ast)
      counter.n_parameters
    end
  end
end
