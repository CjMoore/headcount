require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repo'
require 'pry'
require_relative 'fixtures/kindergarten_basic_fixture.csv'

class DistrictRepoTest < MiniTest::Test

  def test_load_data_makes_districts
    dr = DistrictRepo.new

    dr.load_data({:enrollment => {
                   :kindergarten => 'kindergarten_basic_fixture.csv'
                   }
                })

    district_names = ["ACADEMY 20", "ADAMS COUNTY 14", "AKRON R-1",
                      "ARICKAREE R-2", "KEENESBURG RE-3(J)", "CHERRY CREEK 5",
                      "MIAMI/YODER 60 JT", "WEST YUMA COUNTY RJ-1",
                      "PARK (ESTES PARK)"]

    assert_equal district_names, dr.districts.keys
  end
  #
  # def test_make_districts_makes_districts_with_correct_names
  #   dr = DistrictRepo.new
  #   row = "ACADEMY 20,2007,Percent,0.39159"
  #
  #
  #
  # end

end
