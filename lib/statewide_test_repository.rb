require_relative 'statewide_test'
require_relative 'csv_parser'
require_relative 'data_parser'
require 'pry'

class StatewideTestRepository

  include CsvParser
  include DataParser

  attr_accessor :tests

  def initialize
    @tests = Hash.new
  end

  def load_data(input_data)
    all_files = parse_file_open_with_csv(input_data[:statewide_testing])
    files = get_files_by_type(all_files)

    files.each do |key, value|
      files[key] = get_statewide_testing_data_by_file(key, value)
    end
    make_statewide_tests(files)
  end

  def make_statewide_tests(files)
    districts = files[:third_grade].keys
    districts.each do |district|
      @tests[district] = StatewideTest.new({:name => district,
                                            :third_grade =>
                                            files[:third_grade][district],
                                            :eighth_grade =>
                                            files[:eighth_grade][district],
                                            :math =>
                                            files[:math][district],
                                            :reading =>
                                            files[:reading][district],
                                            :writing =>
                                            files[:writing][district]
                                            })
    end
  end

  def get_files_by_type(files)
    {:third_grade => validate_file(files[0]),
      :eighth_grade => validate_file(files[1]),
      :math => validate_file(files[2]),
      :reading => validate_file(files[3]),
      :writing => validate_file(files[4])}
  end

  def find_by_name(name)
    @tests[name]
  end

end
