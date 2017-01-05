require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repo'
require 'pry'

class DistrictRepoTest < MiniTest::Test

  def test_load_data_makes_districts
    dr = DistrictRepo.new

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
    dr = DistrictRepo.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                   }
                })

    assert_equal District, dr.find_by_name("ACADEMY 20").class
    assert_equal "ACADEMY 20", dr.find_by_name("ACADEMY 20").name
  end

  def test_district_repo_can_find_all_districts_given_substring
    dr = DistrictRepo.new

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
    dr = DistrictRepo.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                   }
                })

    assert_equal [], dr.find_all_matching("X")
  end

  def test_find_all_rejects_names_with_incomplete_match_to_substring
    dr = DistrictRepo.new

    dr.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_find_all_edge.csv'
                   }
                })
    # binding.pry

    assert_equal ["CHEYENNE COUNTY RE-5"], dr.find_all_matching("CHEY")
  end
end
