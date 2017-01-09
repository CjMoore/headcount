require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < MiniTest::Test

  def test_statewide_repository_can_gather_data_by_district
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

    str.load_data(input_data)

    district_names = ["ACADEMY 20", "ADAMS COUNTY 14", "AGUILAR REORGANIZED 6"]

    assert_equal district_names, str.tests.keys
    assert_equal StatewideTest, str.tests.values[0].class
  end


end
