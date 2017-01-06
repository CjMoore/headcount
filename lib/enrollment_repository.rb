require_relative 'enrollment'
require_relative 'parser'
require 'csv'
require 'pry'

class EnrollmentRepository
  include Parser

  attr_reader :enrollment_by_district,
              :enrollments

  def initialize
    @enrollments = Hash.new
  end

  def load_data(input_data)
    file_contents = parse_file_open_with_csv(input_data)
    make_enrollment_objects(gather_enrollment_data_by_district(file_contents))
  end

  def make_enrollment_objects(enrollment_by_district)
    enrollment_by_district.keys.each do |district|
      @enrollments[district] = Enrollment.new({:name => district,
                                              :kindergarten_participation =>
                                              enrollment_by_district[district]})
    end
  end

  def gather_enrollment_data_by_district(file_contents)
    enrollment_by_district = Hash.new
    file_contents.each do |row|
      validate_enrollment_by_district(enrollment_by_district, row)
    end
    enrollment_by_district
  end

  def validate_enrollment_by_district(enrollment_by_district, row)
    if enrollment_by_district.keys.include?(location(row))
      enrollment_by_district[location(row)][time_frame(row)] = data(row)
    else
      enrollment_by_district[location(row)] = Hash.new
      enrollment_by_district[location(row)][time_frame(row)] = data(row)
    end
    enrollment_by_district
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end

end
