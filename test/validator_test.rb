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
  

end
