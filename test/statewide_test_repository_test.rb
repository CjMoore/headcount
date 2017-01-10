# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test_repository'
# require './lib/csv_parser'


class StatewideTestRepositoryTest < MiniTest::Test
  # include CsvParser

  def test_statewide_repository_can_gather_data_by_district
    str = StatewideTestRepository.new

    input_data = {
      :statewide_testing => {
      :third_grade => "./test/fixtures/third_grade_basic.csv",
      :eighth_grade => "./test/fixtures/eighth_grade_basic.csv",
      :math => "./test/fixtures/math_basic.csv",
      :reading => "./test/fixtures/reading_basic.csv",
      :writing => "./test/fixtures/writing_basic.csv"
                            }}

    str.load_data(input_data)

    district_names = ["ACADEMY 20", "ADAMS COUNTY 14", "AGUILAR REORGANIZED 6"]

    assert_equal district_names, str.tests.keys
    assert_equal StatewideTest, str.tests.values[0].class
  end

  def test_can_get_valid_files_by_type
    skip
    str = StatewideTestRepository.new

    input_data = {
      :statewide_testing => {
      :third_grade => "./test/fixtures/third_grade_basic.csv",
      :eighth_grade => "./test/fixtures/eighth_grade_basic.csv",
      :math => "./test/fixtures/math_basic.csv",
      :reading => "./test/fixtures/reading_basic.csv",
      :writing => "./test/fixtures/writing_basic.csv"
                            }}

    files = parse_file_open_with_csv(input_data)
    expected = [:third_grade, :eighth_grade, :math, :reading, :writing]

    assert_equal expected, str.get_files_by_type.keys
  end

  def test_find_by_name
    str = StatewideTestRepository.new

    input_data = {
      :statewide_testing => {
      :third_grade => "./test/fixtures/third_grade_basic.csv",
      :eighth_grade => "./test/fixtures/eighth_grade_basic.csv",
      :math => "./test/fixtures/math_basic.csv",
      :reading => "./test/fixtures/reading_basic.csv",
      :writing => "./test/fixtures/writing_basic.csv"
                            }}

    str.load_data(input_data)

    assert_equal "ACADEMY 20", str.find_by_name("ACADEMY 20").name
  end



end
