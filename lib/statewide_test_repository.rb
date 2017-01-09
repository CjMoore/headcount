require_relative 'statewide_test'
require_relative 'csv_parser'

class StatewideTestRepository

  include CsvParser

  attr_accessor :tests

  def initialize
    @tests = tests
  end

  def load_data(input_data)

  end

end
