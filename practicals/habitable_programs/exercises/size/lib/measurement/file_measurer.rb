require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/file_locator"

module Measurement
  # A FileMeasurer is a specialisation of Measurement::Measurer
  class FileMeasurer < Measurer
    # This method is called by Measurer to determine how we would like to
    # find things to measure (subjects). In this case, we wish to measure
    # source files, so we use my FileLocator class.
    def locator
      Locator::FileLocator.new
    end

    # This method is called by Measurer to perform measurement on a subject
    # (in this case, a source file). We must return a hash which associates
    # the name of a measurement (e.g., lines of code) and the measurement
    # for the given file (e.g, 23).
    def measurements_for(file)
      {
        lines_of_code: count_lines_of_code(file),
        number_of_modules: count_modules(file),
        number_of_classes: count_classes(file)
      }
    end

    def count_lines_of_code(file)
      file.source.lines.to_a.select { |s| not s.strip.empty? }.size
    end

    def count_in_ast(ast, sym)
      n = 0

      if not ast.respond_to?(:type)
        return 0
      end

      if ast.type == sym
        n += 1
      end

      if ast.respond_to?(:children)
        ast.children.each { |child| n += count_in_ast(child, sym) }
      end

      return n
    end

    def count_modules(file)
      count_in_ast(file.ast, :module)
    end

    def count_classes(file)
      count_in_ast(file.ast, :class)
    end
  end
end
