require_relative 'enrollment'
require_relative 'csv_parser'
require_relative 'data_parser'
require 'csv'
require 'pry'

class EnrollmentRepository
  include CsvParser
  include DataParser

  attr_reader :enrollment_by_district,
              :enrollments

  def initialize
    @enrollments = Hash.new
  end

  def load_data(input_data)
    files = parse_file_open_with_csv(input_data).compact
    kindergarten_file = validate_file(files[0])
    high_school_file = validate_file(files[1])

    make_enrollments(get_enrollment_data_by_district(kindergarten_file),
                      get_enrollment_data_by_district(high_school_file))
  end

  def make_enrollments(kindergarten_enrollments, hs_enrollments)
    all_enrollments = kindergarten_enrollments.keys.concat(hs_enrollments.keys).uniq
    all_enrollments.each do |district|
      @enrollments[district] =Enrollment.new({:name => district,
                                            :kindergarten_participation =>
                                            kindergarten_enrollments[district],
                                            :high_school_graduation =>
                                            hs_enrollments[district]})
    end
  end

  def get_enrollment_data_by_district(file_contents)
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

  def validate_file(file)
    if file == nil
      []
    else
      file
    end
  end

  def find_by_name(name)
    @enrollments[name.upcase]
  end
end
