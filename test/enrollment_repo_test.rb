require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repo'


class EnrollmentRepoTest < MiniTest::Test

  def test_enrollment_repo_can_gather_data_by_district
    er = EnrollmentRepo.new

    er.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                  }
                })

    district_names = ["ACADEMY 20", "ADAMS COUNTY 14", "AKRON R-1",
                      "ARICKAREE R-2", "KEENESBURG RE-3(J)", "CHERRY CREEK 5",
                      "MIAMI/YODER 60 JT", "WEST YUMA COUNTY RJ-1",
                      "PARK (ESTES PARK) R-3"]

    assert_equal district_names, er.enrollments.keys
    assert_equal Enrollment, er.enrollments.values[0].class
  end

  

end
