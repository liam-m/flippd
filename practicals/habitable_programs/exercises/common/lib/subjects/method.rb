require_relative "subject"

module Subjects
  class Method < Subject
    attr_reader :source_file, :ast

    def initialize(source_file, ast)
      @source_file = source_file
      @ast = ast
    end

    def to_s
      "#{file_name}##{method_name}"
    end

    def file_name
      source_file.to_s
    end

    def method_name
      if ast.type == :block
        target = ast.children[0]

        method_name = target.children[1]

        if target.children[0].nil?
          if [:get, :post].include?(method_name)
            route = target.children[2].children[0]
            method_name.to_s + ' \'' + route + '\''
          else
            method_name
          end
        end
      else
        ast.children.first.to_s
      end
    end
  end
end
