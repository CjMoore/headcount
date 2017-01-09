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
    files = parse_file_open_with_csv(input_data[:enrollment]).compact
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

  def find_by_name(name)
    @enrollments[name.upcase]
  end
end
