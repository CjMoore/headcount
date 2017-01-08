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

  def test_analyst_can_get_kindergarten_enrollment_data_from_district_repo
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

    assert_in_delta 0.766,
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

    assert_equal 0.96,
                ha.enrollment_data_average_in_year(year, district, compare)
  end

  def test_kindergarten_participation_rate_variation_tren
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_with_colorado.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)

    district = ("ACADEMY 20")
    compare = {:against => "COLORADO"}
    trend_data = {2004 => 1.258, 2005 => 0.96, 2006 => 1.051, 2007 => 0.992,
                  2008 => 0.718, 2009 => 0.652, 2010 => 0.681, 2011 => 0.728,
                  2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }

    assert_equal trend_data,
           ha.kindergarten_participation_rate_variation_trend(district, compare)
  end

  def test_kindergarten_participation_against_high_school_graduation
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_steamboat_state.csv',
                  :high_school_graduation =>
                  './test/fixtures/steamboat_high_school_colorado.csv'
                  }

                })

    ha = HeadcountAnalyst.new(dr)
    district = "STEAMBOAT SPRINGS RE-2"

    assert_in_delta 0.800,
    ha.kindergarten_participation_against_high_school_graduation(district)
  end

  def test_analyst_can_get_high_school_data_from_district_repo
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv',
                  :high_school_graduation =>
                  './test/fixtures/high_school_basic.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    district = "ACADEMY 20"
    expected = {2011 => 0.895, 2012 => 0.889}

    assert_equal expected, ha.high_school_graduation_data(district)
  end

  def test_graduation_data_average_takes_data_gives_average
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv',
                  :high_school_graduation =>
                  './test/fixtures/high_school_basic.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    graduation_data = {2011 => 0.895, 2012 => 0.889}

    assert_in_delta 0.892, ha.graduation_data_average(graduation_data)
  end

  def test_can_get_graduation_data_average
    dr = DistrictRepository.new
    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv',
                  :high_school_graduation =>
                  './test/fixtures/high_school_basic.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    district = "ACADEMY 20"

    assert_equal 0.892, ha.get_graduation_data_average(district)
  end

  def test_kindergarten_participation_correlates_with_graduation
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_steamboat_state.csv',
                  :high_school_graduation =>
                  './test/fixtures/steamboat_high_school_colorado.csv'
                  }

                })

    ha = HeadcountAnalyst.new(dr)
    d = ({:for => "STEAMBOAT SPRINGS RE-2"})

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(d)
  end

  def check_correlation_value
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_steamboat_state.csv',
                  :high_school_graduation =>
                  './test/fixtures/steamboat_high_school_colorado.csv'
                  }

                })

    ha = HeadcountAnalyst.new(dr)
    district = "STEAMBOAT SPRINGS RE-2"

    assert_equal 0.892, correlation_value(district)
  end

  def test_if_correlation_value_falls_in_range
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_steamboat_state.csv',
                  :high_school_graduation =>
                  './test/fixtures/steamboat_high_school_colorado.csv'
                  }

                })

    ha = HeadcountAnalyst.new(dr)

    correlation_value = 0.892
    correlation_value2 = 0.1

    assert ha.correlation_fall_in_range?(correlation_value)
    refute ha.correlation_fall_in_range?(correlation_value2)
  end

  def test_check_district_or_state_wide
    dr = DistrictRepository.new

    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv',
                  :high_school_graduation =>
                  './test/fixtures/high_school_basic.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    district = {:for => "ADAMS COUNTY 14"}
    statewide = {:for => "STATEWIDE"}
    districts = ["ADAMS COUNTY 14", "AKRON R-1", "ARICKAREE R-2",
                  "KEENESBURG RE-3(J)", "CHERRY CREEK 5", "MIAMI/YODER 60 JT",
                  "WEST YUMA COUNTY RJ-1", "PARK (ESTES PARK) R-3"]

    assert_equal "ADAMS COUNTY 14", ha.check_district_or_statewide(district)
    assert_equal districts, ha.check_district_or_statewide(statewide)
  end

  def test_can_get_correlation_truth_value_for_each_district_given
    dr = DistrictRepository.new

    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kinder_positive_correlation.csv',
                  :high_school_graduation =>
                  'test/fixtures/hs_postive_correlation.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    statewide = {:for => "STATEWIDE"}
    expected = [true, true, false, true]
    districts = ha.check_district_or_statewide(statewide)

    assert_equal expected, ha.correlation_values_for_districts(districts)
  end

  def test_get_percentage_of_positive_correlation
    dr = DistrictRepository.new

    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kinder_positive_correlation.csv',
                  :high_school_graduation =>
                  'test/fixtures/hs_postive_correlation.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    correlation_values = [true, true, false, true]

    assert_equal 0.75, ha.calculate_positive_correlation(correlation_values)
  end

  def test_positive_statewide_correlation_values
    dr = DistrictRepository.new

    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kinder_positive_correlation.csv',
                  :high_school_graduation =>
                  'test/fixtures/hs_postive_correlation.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    statewide = {:for => "STATEWIDE"}

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(statewide)
  end

  def test_negative_statewide_correlation_values
    dr = DistrictRepository.new

    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kinder_negative_correlation.csv',
                  :high_school_graduation =>
                  'test/fixtures/hs_negative_correlation.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    statewide = {:for => "STATEWIDE"}

    refute ha.kindergarten_participation_correlates_with_high_school_graduation(statewide)
  end

  def test_can_get_correlations_across_given_districts
    dr = DistrictRepository.new

    dr.load_data(({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kinder_positive_correlation.csv',
                  :high_school_graduation =>
                  'test/fixtures/hs_postive_correlation.csv'
                  }
                }))

    ha = HeadcountAnalyst.new(dr)
    across = {:across => ["ACADEMY 20", "PARK (ESTES PARK) R-3"]}

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(across)
  end

end
