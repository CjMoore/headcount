require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'

class DistrictTest < MiniTest::Test

  def test_district_can_take_name
    district = District.new({:name =>"Academy 20"})

    assert_equal "Academy 20", district.name
  end


end
