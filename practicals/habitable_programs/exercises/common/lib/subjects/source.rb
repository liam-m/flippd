def interesting?(frag)
    # If ANY of the lines is the "end, class, module, return or self" keyword, it is not interesting.
    # This prevents clones containing these common keywords as they are not interesting.
    frag.each do |line|
        if ["end", "class", "module", "self", "return"].include?(line.strip.split(" ")[0])
            return false
        end
    end

    true
end

module Subjects
  # Represents a piece of source code, which (probably) came from a file
  class Source
    # The entire source represented as an array of lines (strings)
    attr_reader :lines

    # The SourceFile that contains this source code. This attribute is nil
    # when the source code is not stored on (local) disk
    attr_reader :file

    def initialize(lines, file = nil)
      @lines, @file = lines.to_a, file
    end

    # Returns a fragment that is common to `self` and `other_source` and that is
    # longer than any other common fragment. Note that when `self` and `other_source`
    # have no common fragments, a zero-length fragment (`[]`) is returned.
    def longest_common_fragment_with(other_source, threshold=2)
      lines.size.downto(threshold) do |fragment_size|
        common_fragment = common_fragment_with(other_source, fragment_size)
        if not common_fragment.nil?
          return common_fragment
        end
      end

      []
    end

    def all_common_fragments_with(other_source, threshold=2)
      # TODO: An outstanding implementation of this method will ensure that the results
      # contain no overlapping fragments. For example, if hello_world.rb:5-20 is a
      # fragment, then hello_world.rb:6-19 should not be returned (because the latter is
      # wholly contained in the former).

      common_fragments = []

      lines.size.downto(threshold) do |fragment_size|
        fragments(fragment_size).select { |frag| interesting?(frag) }.each do |f1|
          other_source.fragments(fragment_size).each do |f2|
            if f1 == f2
              common_fragments << f1
              break
            end
          end
        end
      end

      common_fragments
    end

    # Returns a fragments that appear in both `self` and in `other_source`
    # of the specified size.
    def common_fragment_with(other_source, fragment_size)
      all_common_fragments_with(other_source).select { |common_fragment| common_fragment.size == fragment_size }.first
    end

    # Returns all fragments of a given size, where a fragment is an array containing
    # a subset of lines in the original source. It might help to note that:
    #  * fragments(lines.size).to_a == [lines]
    #  * fragments(1).to_a == lines.map { |l| [l] }
    def fragments(size)
      lines.each_cons(size)
    end
  end
end