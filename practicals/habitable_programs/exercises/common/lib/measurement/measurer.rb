require_relative "../subjects/project"
require_relative "measured_subject"

module Measurement
  class Measurer
    attr_accessor :subjects

    def initialize(root, result_presenter = Table)
      @subjects = locator.find_subjects_in(Subjects::Project.new(root))
      @results = result_presenter.new
    end

    def locator
      fail "Must be implemented by subclasses"
    end

    def run
      @results.add_row(measured_subjects.first.descriptions) # header
      @results.add_rows(measured_subjects.map(&:values)) # body
      puts @results
    end

    def measured_subjects
      @measured_subjects ||= subjects.map { |s| MeasuredSubject.new(s, measurements_for(s)) }
    end

    def measurements_for(_subject)
      fail "Must be implemented by subclasses"
    end
  end

  class ResultPresenter
    def initialize
      @rows = []
    end

    def add_rows(rows)
      rows.each { |r| add_row(r) }
    end

    def add_row(cells)
      @rows << cells
    end

    def to_s
      @rows.map { |r| row_to_s(r) }.join("\n")
    end
  end

  class CSV < ResultPresenter
    def row_to_s(cells)
      cells.join(",")
    end
  end

  class TSV < ResultPresenter
    def row_to_s(cells)
      cells.join("\t")
    end
  end

  class Table < ResultPresenter
    def row_to_s(cells)
      "| " + cells.each_with_index.map { |cell, index| cell_to_s(cell, index) }.join(" | ") + " |"
    end

    def cell_to_s(cell, column_index)
      cell.to_s.ljust(width_for_column(column_index))
    end

    def width_for_column(index)
      @rows.map { |r| r[index].to_s.size }.max
    end
  end
end
