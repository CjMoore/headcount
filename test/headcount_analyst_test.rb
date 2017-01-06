require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require 'pry'


class HeadcountAnalystTest < MiniTest::Test

  def test_headcount_analyst_can_take_in_district
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_with_colorado.csv'}
                  }))

      ha = HeadcountAnalyst.new(dr)
      assert_equal DistrictRepository, ha.district_repo.class
  end

  def test_analyst_can_get_enrollment_data_from_district_repo
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    district_name = "ACADEMY 20"

    enrollment_data = {2007 => 0.391, 2011 => 0.489}
    # binding.pry
    assert_equal enrollment_data,
                ha.kindergarten_enrollment_data(district_name)

  end

  def test_get_enrollment_data_average
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    district_name = "ACADEMY 20"
    enrollment_data = ha.kindergarten_enrollment_data(district_name)

    assert_equal 0.440, ha.enrollment_data_average(enrollment_data)

  end

  def test_get_enrollment_data_average_given_district
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    district_name = "ACADEMY 20"

    assert_equal 0.440, ha.get_enrollment_data_average(district_name)
  end

  def test_kindergarten_participation_rate_variation_compaires_district_to_state
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_with_colorado.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    district = "ACADEMY 20"
    compare = {:against => "COLORADO"}

    assert_equal 0.766,
    ha.kindergarten_participation_rate_variation(district, compare)
  end

  def test_kindergarten_participation_rate_compared_to_other_district
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/academy20_vs_yuma1.csv'
                  }
                  }))

    ha = HeadcountAnalyst.new(dr)
    district = "ACADEMY 20"
    compare = {:against => "YUMA SCHOOL DISTRICT 1"}

    assert_equal 0.447,
    ha.kindergarten_participation_rate_variation(district, compare)
  end

  def test_can_get_enrollment_data_for_a_given_year
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_with_colorado.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    district_name = "ACADEMY 20"

    assert_equal 0.489, ha.enrollment_data_in_year(2011, district_name)
  end

  def test_can_get_years_kindergarten
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_with_colorado.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)

    district_name = "ACADEMY 20"
    years = [2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014]

    assert_equal years, ha.get_years_kindergarten(district_name)
  end

  def test_can_get_enrollment_data_average_for_given_year
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_with_colorado.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)

    district = ("ACADEMY 20")
    compare = {:against => "COLORADO"}
    year = 2005

    assert_equal 0.96, ha.enrollment_data_average_in_year(year, district, compare)
  end

  def test_kindergarten_participation_rate_variation_trend
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_with_colorado.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)

    district = ("ACADEMY 20")
    compare = {:against => "COLORADO"}
    trend_data = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992,
                  2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727,
                  2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }

    assert_equal trend_data,
    ha.kindergarten_participation_rate_variation_trend(district, compare)
  end
end
