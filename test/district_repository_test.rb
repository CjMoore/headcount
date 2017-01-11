# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../headcount/lib/district_repository'
require_relative'../../headcount/lib/enrollment_repository'
require_relative '../../headcount/lib/enrollment'
require_relative '../../headcount/lib/statewide_test_repository'
require_relative '../../headcount/lib/statewide_test'
require 'pry'

class DistrictRepoitoryTest < MiniTest::Test

  def test_load_data_makes_districts
    dr = DistrictRepository.new


    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                  }
                })

    district_names = ["ACADEMY 20", "ADAMS COUNTY 14", "AKRON R-1",
                      "ARICKAREE R-2", "KEENESBURG RE-3(J)", "CHERRY CREEK 5",
                      "MIAMI/YODER 60 JT", "WEST YUMA COUNTY RJ-1",
                      "PARK (ESTES PARK) R-3"]

    assert_equal district_names, dr.districts.keys
  end

  def test_district_repo_can_find_by_name
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                   }
                })

    assert_equal District, dr.find_by_name("ACADEMY 20").class
    assert_equal "ACADEMY 20", dr.find_by_name("ACADEMY 20").name
  end

  def test_district_repo_can_find_all_districts_given_substring
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                   }
                })

    looking_for = ["ACADEMY 20", "ADAMS COUNTY 14", "AKRON R-1",
                    "ARICKAREE R-2"]

    assert_equal looking_for, dr.find_all_matching("A")
  end

  def test_district_repo_find_all_returns_empty_array_for_invalid_substring
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                   }
                })

    assert_equal [], dr.find_all_matching("X")
  end

  def test_find_all_rejects_names_with_incomplete_match_to_substring
    dr = DistrictRepository.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_find_all_edge.csv'
                   }
                })

    assert_equal ["CHEYENNE COUNTY RE-5"], dr.find_all_matching("CHEY")
  end

  def test_district_repo_makes_enrollment_repo_links
    dr = DistrictRepository.new

    input_data = {:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                   }
                }

     dr.load_data(input_data)
     assert_equal 0.489,
     dr.districts["ACADEMY 20"].enrollment.kindergarten_participation_in_year(2011)
  end

  def test_district_repo_makes_statewide_testing_repo_links
    dr = DistrictRepository.new

    input_data = ({
                    :enrollment => {
                      :kindergarten => "./test/fixtures/kinder_matching.csv",
                      :high_school_graduation => "./test/fixtures/hs_matching.csv",
                    },
                    :statewide_testing => {
                      :third_grade => "./test/fixtures/third_grade_basic.csv",
                      :eighth_grade => "./test/fixtures/eighth_grade_basic.csv",
                      :math => "./test/fixtures/math_basic.csv",
                      :reading => "./test/fixtures/reading_basic.csv",
                      :writing => "./test/fixtures/writing_basic.csv"
                    }
                  })

    dr.load_data(input_data)
    district = dr.find_by_name("ACADEMY 20")

    assert_equal 0.816,
    district.statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2011)
  end

  def test_district_repo_makes_economic_profile_links
    input_data = {
                    :enrollment => {
                      :kindergarten => "./test/fixtures/kinder_matching.csv",
                      :high_school_graduation => "./test/fixtures/hs_matching.csv",
                    },
                    :statewide_testing => {
                      :third_grade => "./test/fixtures/third_grade_basic.csv",
                      :eighth_grade => "./test/fixtures/eighth_grade_basic.csv",
                      :math => "./test/fixtures/math_basic.csv",
                      :reading => "./test/fixtures/reading_basic.csv",
                      :writing => "./test/fixtures/writing_basic.csv"
                    },
                    :economic_profile => {
                      :median_household_income => "./test/fixtures/median_income_basic.csv",
                      :children_in_poverty => "./test/fixtures/children_poverty_basic.csv",
                      :free_or_reduced_price_lunch => "./test/fixtures/free_reduced_lunch_basic.csv",
                      :title_i => "./test/fixtures/title_i_basic.csv"
                            }
                  }

    dr = DistrictRepository.new
    dr.load_data(input_data)

    district = dr.find_by_name("ACADEMY 20")

    assert_in_delta 0.064, district.economic_profile.children_in_poverty_in_year(2012), 0.005
  end

end
