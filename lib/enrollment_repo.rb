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
    @enrollment_by_district = Hash.new
  end

  def load_data(input_data)
    file_contents = parse_file_open_with_csv(input_data)

    file_contents.each do |row|
      if @enrollment_by_district.keys.include?(row[:location])
        @enrollment_by_district[row[:location]][row[:timeframe]] = row[:data].ljust(3)
      else
        @enrollment_by_district[row[:location]] = Hash.new
        @enrollment_by_district[row[:location]][row[:timeframe]] = row[:data].ljust(3)
      end
    end

    @enrollment_by_district.keys.each do |district|
      @enrollments[district] = Enrollment.new({:name => district,
                                :kindergarten_participation => @enrollment_by_district[district]})
    end
  end

end
