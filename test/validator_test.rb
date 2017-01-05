require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/validator'


class ValidatorTest < MiniTest::Test

  include Validator

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

  def test_validate_enrollment_by_district_makes_new_hash_for_new_district
    skip
    enrollment_by_district = Hash.new

    row = ACADEMY 20,2007,Percent,0.39159

    refute enrollment_by_district.keys.include?("ACADEMY 20")

  end

end
