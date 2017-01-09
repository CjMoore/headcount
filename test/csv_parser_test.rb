require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/csv_parser'
require 'pry'


class CsvParserTest < Minitest::Test

  include CsvParser

  def test_parse_input_data_to_file_returns_file
    input = {:enrollment => {
                    :kindergarten => './test/fixture/kindergarten_basic_fixture.csv'
                    }
            }

    assert_equal './test/fixture/kindergarten_basic_fixture.csv',
                  parse_kindergarten_enrollment_to_file(input)
  end

  def test_parse_high_school_graduation_to_file
    input = {:enrollment => {
            :kindergarten => "./test/fixture/kindergarten_basic_fixture.csv",
            :high_school_graduation => "./test/fixture/High_school_basic_fixture.csv"}}

    assert_equal './test/fixture/High_school_basic_fixture.csv',
                  parse_high_school_graduation_to_file(input)
  end
end
