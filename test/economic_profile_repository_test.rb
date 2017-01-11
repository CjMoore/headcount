require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../headcount/lib/economic_profile_repository'

class EconomicProfileRepositoryTest < MiniTest::Test

  def test_economic_repository_can_gather_data_by_district
    epr = EconomicProfileRepository.new

    input_data = ({
                :economic_profile => {
                  :median_household_income => "./test/fixtures/median_income_basic.csv",
                  :children_in_poverty => "./test/fixtures/children_poverty_basic.csv",
                  :free_or_reduced_price_lunch => "./test/fixtures/free_reduced_lunch_basic.csv",
                  :title_i => "./test/fixtures/title_i_basic.csv"
                        }
                    })

    epr.load_data(input_data)


    district_names = ["ACADEMY 20", "ADAMS COUNTY 14", "AGUILAR REORGANIZED 6"]

    assert_equal district_names, epr.profiles.keys
    assert_equal EconomicProfile, epr.profiles.values[0].class

  end

  def test_find_by_name
    epr = EconomicProfileRepository.new

    input_data = ({
                :economic_profile => {
                  :median_household_income => "./test/fixtures/median_income_basic.csv",
                  :children_in_poverty => "./test/fixtures/children_poverty_basic.csv",
                  :free_or_reduced_price_lunch => "./test/fixtures/free_reduced_lunch_basic.csv",
                  :title_i => "./test/fixtures/title_i_basic.csv"
                        }
                    })

    epr.load_data(input_data)

    assert_equal EconomicProfile, epr.find_by_name("ACADEMY 20").class
    assert_equal "ACADEMY 20", epr.find_by_name("ACADEMY 20").name
  end



end
