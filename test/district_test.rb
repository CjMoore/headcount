# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../headcount/lib/district'
require_relative '../../headcount/lib/enrollment'

class DistrictTest < MiniTest::Test

  def test_district_can_take_name_and_is_upcased
    district = District.new({:name =>"Academy 20"})

    assert_equal "ACADEMY 20", district.name
  end

  def test_district_can_have_linked_enrollment_and_access_data
    district = District.new({:name =>"Academy 20"})
    enrollment = Enrollment.new({:name => "ACADEMY 20",
                                 :kindergarten_participation => {
                                  2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})

    district.enrollment = enrollment
    expected = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}

    assert_equal expected, district.enrollment.kindergarten_participation_by_year
  end

  def test_district_can_access_graduation_data
    district = District.new({:name =>"Academy 20"})
    enrollment = Enrollment.new({:name => "ACADEMY 20",
                                :high_school_graduation => {
                                2010 => 0.895, 2011 => 0.895, 2012 => 0.889
                                  }})

    district.enrollment = enrollment
    expected = {2010 => 0.895, 2011 => 0.895, 2012 => 0.889}

    assert_equal expected, district.enrollment.graduation_rate_by_year
  end

end
