require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repo'
require 'pry'

class DistrictRepoTest < MiniTest::Test

  def test_load_data_makes_districts
    dr = DistrictRepo.new

    file =

    dr.load_data({:enrollment => {
                   :kindergarten => './test/fixtures/kindergarten_basic_fixture.csv'
                   }
                })

    district_names = ["ACADEMY 20", "ADAMS COUNTY 14", "AKRON R-1",
                      "ARICKAREE R-2", "KEENESBURG RE-3(J)", "CHERRY CREEK 5",
                      "MIAMI/YODER 60 JT", "WEST YUMA COUNTY RJ-1",
                      "PARK (ESTES PARK) R-3"]


    assert_equal district_names, dr.districts.keys
  end


end
