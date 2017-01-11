# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../headcount/lib/enrollment_repository'

class EnrollmentRepositoryTest < MiniTest::Test

  def test_enrollment_repo_can_gather_data_by_district
    er = EnrollmentRepository.new

    er.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv',
                  :high_school_graduation =>
                  './test/fixtures/high_school_basic.csv'
                  }
                  })

    district_names = ["ACADEMY 20", "ADAMS COUNTY 14", "AKRON R-1",
                      "ARICKAREE R-2", "KEENESBURG RE-3(J)", "CHERRY CREEK 5",
                      "MIAMI/YODER 60 JT", "WEST YUMA COUNTY RJ-1",
                      "PARK (ESTES PARK) R-3"]

    assert_equal district_names, er.enrollments.keys
    assert_equal Enrollment, er.enrollments.values[0].class
  end

  def test_find_by_name
    er = EnrollmentRepository.new

    er.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv'
                  }
                })


    assert_equal "ACADEMY 20", er.find_by_name("ACADEMY 20").name
  end

  def test_enrollment_repo_assigns_graduation_data
    er = EnrollmentRepository.new

    er.load_data({:enrollment => {
                  :kindergarten =>
                  './test/fixtures/kindergarten_basic_fixture.csv',
                  :high_school_graduation =>
                  './test/fixtures/high_school_basic.csv'
                  }
                  })
    expected = {2011 => 0.895, 2012 => 0.889}

    assert_equal expected, er.enrollments["ACADEMY 20"].graduation_rate_by_year
  end

end
