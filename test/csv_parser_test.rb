# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../headcount/lib/csv_parser'
require 'pry'


class CsvParserTest < Minitest::Test

  include CsvParser

  def test_parse_enrollment_files
    input = {:kindergarten => "./test/fixture/kindergarten_basic_fixture.csv",
            :high_school_graduation => "./test/fixture/High_school_basic_fixture.csv"}

    expected = ["./test/fixture/kindergarten_basic_fixture.csv",
                "./test/fixture/High_school_basic_fixture.csv"]

    assert_equal expected, get_enrollment_files(input)
    assert_equal expected, check_enrollment_testing_or_economic_files(input)

  end

  def test_parse_statewide_testing_files
    input = {:third_grade => "./test/fixtures/third_grade_basic.csv",
            :eighth_grade => "./test/fixtures/eighth_grade_basic.csv",
            :math => "./test/fixtures/math_basic.csv",
            :reading => "./test.fixtures/reading_basic.csv",
            :writing => "./test/fixtures/writing_basic.csv"
            }

    expected = ["./test/fixtures/third_grade_basic.csv",
                "./test/fixtures/eighth_grade_basic.csv",
                "./test/fixtures/math_basic.csv",
                "./test.fixtures/reading_basic.csv",
                "./test/fixtures/writing_basic.csv"]

    assert_equal expected, get_testing_files(input)
    assert_equal expected, check_enrollment_testing_or_economic_files(input)
  end

  def test_can_parse_economic_profile_files
    input = {:median_household_income => "./test/fixtures/median_income_basic.csv",
    :children_in_poverty => "./test/fixtures/children_poverty_basic.csv",
    :free_or_reduced_price_lunch => "./test/fixtures/free_reduced_lunch_basic.csv",
    :title_i => "./test/fixtures/title_i_basic.csv"}

    expected = ["./test/fixtures/median_income_basic.csv",
                "./test/fixtures/children_poverty_basic.csv",
                "./test/fixtures/free_reduced_lunch_basic.csv",
                "./test/fixtures/title_i_basic.csv"]

    assert_equal expected, get_economic_files(input)
    assert_equal expected, check_enrollment_testing_or_economic_files(input)
  end


  # def test_location_gets_location
  #   row = <CSV::Row location:"ACADEMY 20" timeframe:"2007" dataformat:"Percent" data:"0.39159">
  #
  #   assert_equal "ACADEMY 20", location(row)
  # end


end
