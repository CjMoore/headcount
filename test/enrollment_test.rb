require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'

class EnrollmentTest < MiniTest::Test

  def test_enrollment_can_get_name_and_data
    enrollment = Enrollment.new({:name => "ACADEMY 20",
                                 :kindergarten_participation => {
                                  2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    data = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
    binding.pry
    assert_equal "ACADEMY 20", enrollment.name
    assert_equal data, enrollment.kindergarten_data
  end

  def test_kindergarten_participation_by_year_returns_data
    enrollment = Enrollment.new({:name => "ACADEMY 20",
                                 :kindergarten_participation => {
                                  2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    data = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}

    assert_equal data, enrollment.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year_gives_data_for_given_year
    enrollment = Enrollment.new({:name => "ACADEMY 20",
                                :kindergarten_participation => {
                                2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    assert_equal 0.392, enrollment.kindergarten_participation_in_year(2010)
  end
end
