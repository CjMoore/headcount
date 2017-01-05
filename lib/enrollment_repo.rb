require_relative 'enrollment'
require_relative 'parser'
require 'csv'
require 'pry'

class EnrollmentRepo
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
    if enrollment_by_district.keys.include?(row[:location])
      enrollment_by_district[row[:location]][(row[:timeframe].to_i)] = row[:data][0..4].to_f
    else
      enrollment_by_district[row[:location]] = Hash.new
      enrollment_by_district[row[:location]][(row[:timeframe].to_i)] = row[:data][0..4].to_f
    end
    enrollment_by_district
  end

end
