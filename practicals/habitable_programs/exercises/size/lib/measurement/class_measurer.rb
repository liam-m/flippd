require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/class_locator"

module Measurement
  class ClassCounter < Parser::AST::Processor
    attr_reader :n_methods, :n_class_methods, :n_attributes

    def initialize
      @n_methods, @n_class_methods, @n_attributes = 0, 0, 0
    end

    def on_def(node)
      super(node)
      @n_methods += 1
    end

    def on_defs(node)
      super(node)
      @n_class_methods += 1
    end

    def on_ivasgn(node)
      super(node)
      @n_attributes += 1
    end
  end

  class ClassMeasurer < Measurer
    def locator
      Locator::ClassLocator.new
    end

    def measurements_for(clazz)
      {
        lines_of_code: count_lines_of_code(clazz),
        number_of_methods: count_methods(clazz),
        number_of_class_methods: count_class_methods(clazz),
        number_of_attributes: count_attributes(clazz)
      }
    end

    def count_lines_of_code(clazz)
      clazz.source.lines.to_a.size
    end

    def count_methods(clazz)
      counter = ClassCounter.new
      counter.process(clazz.ast)
      counter.n_methods
    end

    def count_class_methods(clazz)
      counter = ClassCounter.new
      counter.process(clazz.ast)
      counter.n_class_methods
    end

    def count_attributes(clazz)
      counter = ClassCounter.new
      counter.process(clazz.ast)
      counter.n_attributes
    end
  end
end
