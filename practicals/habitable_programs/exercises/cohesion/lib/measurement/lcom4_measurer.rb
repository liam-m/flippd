require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/module_locator"
require_relative "dependency_graph"

module Measurement
  class LCOM4Measurer < Measurer
    def locator
      Locator::ModuleLocator.new
    end

    def measurements_for(clazz)
      dependencies = process(clazz)

      {
        lcom4: dependencies.number_of_components,
        connected_components: dependencies.components_summary
      }
    end

    def process(clazz)
      processor = ClassProcessor.new(clazz.ast)
      processor.process(clazz.ast)
      processor.dependencies
    end
  end

  class ClassProcessor < Parser::AST::Processor
    def initialize(root)
      @root = root
    end

    # Ignore nested modules
    def on_module(ast)
      super if ast == @root
    end

    # Ignore nested classes
    def on_class(ast)
      super if ast == @root
    end

    def on_def(ast)
      method_processor = MethodProcessor.new
      method_processor.process(ast)

      method_processor.methods_to_self.each do |method|
        dependencies.add(ast.children[0], method)
      end

      super
    end

    def dependencies
      @dependencies ||= DependencyGraph.new
    end
  end

  class MethodProcessor < Parser::AST::Processor
    # MethodProcessor will be responsible for recognising when a send statement has been
    # encountered in a specific method's AST, checking to see if the message is being sent
    # to self (i.e., a method defined on the current class is being invoked), and returning
    # a set of all of the messages sent to self. For example, when applied to the following
    # method, MethodProcessor would return the following array of messages: [:roll, :cook]
    # and ClassProcessor would associate the array with :bake in the DependencyGraph.
    # (Note that the message top! is sent to @toppings and not to self).

    attr_reader :methods_to_self

    def initialize
      @methods_to_self = []
    end

    def on_send(node)
      super(node)

      if node.children[0].nil? # Send to self
        @methods_to_self << node.children[1]
      end
    end
  end
end
