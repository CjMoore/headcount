require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/parser'


class ParserTest < Minitest::Test

  include Parser

  def test_parse_input_data_to_file_returns_file
    input = {:enrollment => {
                    :kindergarten => 'kindergarten_basic_fixture.csv'
                    }
            }

    assert_equal 'kindergarten_basic_fixture.csv', parse_kindergarten_enrollment_to_file(input)
  end


end
