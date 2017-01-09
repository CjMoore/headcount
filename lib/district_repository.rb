require_relative 'district'
require_relative 'csv_parser'
require_relative 'substring_validator'
require_relative 'enrollment_repository'
require_relative 'enrollment'
require_relative 'statewide_test_repository'
require_relative 'statewide_test'
require 'csv'
require 'pry'

class DistrictRepository
  include CsvParser
  include SubstringValidator

  attr_reader :districts

  def initialize
    @districts = Hash.new
  end

  def load_data(input_data)
    enrollment_data = parse_file_open_with_csv(input_data[:enrollment])
    file_contents = enrollment_data[0]
    file_contents.each do |row|
      @districts[(location(row))] = District.new({:name => location(row)})
    end
    district_enrollment_link(make_enrollment_repo(input_data))
  end

  def make_enrollment_repo(input_data)
    enroll = EnrollmentRepository.new
    enroll.load_data(input_data)
    enroll.enrollments
  end

  def district_enrollment_link(enrollment_data)
    @districts.each do |district|
      district[1].enrollment = enrollment_data[district[0]]
    end
  end

  def find_by_name(name)
    @districts[name.upcase]
  end

  def find_all_matching(name_substring)
    @districts.keys.collect do |district|
        validate_districts_contain_substring(district, name_substring)
    end.compact
  end

end
