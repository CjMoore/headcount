require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/substring_validator'

class SubstringValidatorTest < MiniTest::Test
  include SubstringValidator

  def test_validator_validates_substring_length_with_single_letter
    name_substring = "A"

    assert_equal 0, validate_substring_length(name_substring)
  end

  def test_validator_validates_substring_length_with_long_substring
    name_substring = "CHER"

    assert_equal 4, validate_substring_length(name_substring)
  end

  def test_can_return_district_given_valid_substring
    name_substring = "CHER"

    district = "CHERRY CREEK"

    assert_equal district, validate_districts_contain_substring(district, name_substring)
  end
end
