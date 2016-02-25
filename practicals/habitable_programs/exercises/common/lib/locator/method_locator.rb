require_relative "../subjects/method"

module Locator
  class MethodLocator
    def find_subjects_in(project)
      project.files.flat_map do |source_file|
        processor = FindMethodProcessor.new(source_file)
        processor.process(source_file.ast)
        processor.methods
      end
    end

    class FindMethodProcessor < Parser::AST::Processor
      attr_reader :methods

      def initialize(source_file)
        @source_file = source_file
        @methods = []
      end

      def on_def(node)
        super(node)
        @methods << Subjects::Method.new(@source_file, node)
      end

      def on_block(node)
        super(node)
        sinatra_methods = [:before, :after, :get, :post, :put, :patch, :delete, :options, :link, :unlink, :route]
        first_child = node.children[0]

        target = first_child.children[0]
        method_name = first_child.children[1]

        if target.nil? # To self
          if sinatra_methods.include?(method_name) # We care about the method
              @methods << Subjects::Method.new(@source_file, node)
          end
        end
      end
    end
  end
end
