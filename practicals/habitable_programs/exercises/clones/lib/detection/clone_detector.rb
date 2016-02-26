require_relative "../../../common/lib/subjects/project"
require_relative "clone"

module Detection
  class CloneDetector
    def initialize(root)
      @project = Subjects::Project.new(root)
    end

    def run
      @project.files.each do |file|
        clones = clones_for(file)
        print_clones(file, clones)
      end
    end

    def clones_for(file)
      @project
       .files_other_than(file)
       .flat_map { |other_file| clones_between(file.parameterized_source, other_file.parameterized_source) }
       .sort
       .reverse
    end

    def print_clones(file, clones)
      puts "#{file}"
      puts "-"*file.to_s.size
      clones.each { |c| puts c }
      puts ""
    end

    def clones_between(source, other_source)
      source.all_common_fragments_with(other_source).map do |common_fragment|
        Clone.new(source, other_source, common_fragment)
      end
    end
  end
end
