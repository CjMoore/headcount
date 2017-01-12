# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../headcount/lib/data_parser'
require_relative '../../headcount/lib/csv_parser'
require 'pry'


class DataParserTest < MiniTest::Test

  include DataParser
  include CsvParser

  def test_data_parser_can_get_enrollment_by_district
    skip
    input = {:kindergarten => './test/fixtures/kindergarten_basic_fixture.csv'}

    csv = parse_file_open_with_csv(input)
    binding.pry
    expected = {"ACADEMY 20" => {2007 => 0.391, 2011=> 0.489}}

    assert_equal expected, get_enrollment_data_by_district(csv[0])
  end


end
