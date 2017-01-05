require_relative 'enrollment'
require_relative 'parser'
require_relative 'validator'
require 'csv'
require 'pry'

class EnrollmentRepo
  include Parser
  include Validator

  attr_reader :enrollment_by_district,
              :enrollments

  def initialize
    @enrollments = Hash.new
    # @enrollment_by_district = Hash.new
  end

  def load_data(input_data)
    file_contents = parse_file_open_with_csv(input_data)
    enrollment_by_district = Hash.new

    # binding.pry
    file_contents.each do |row|
      validate_enrollment_by_district(enrollment_by_district, row)
    end

    enrollment_by_district.keys.each do |district|
      @enrollments[district] = Enrollment.new({:name => district,
                                            :kindergarten_participation =>
                                            enrollment_by_district[district]})
    end
  end
end
