require_relative 'district'
require_relative 'parser'
require_relative 'validator'
require 'csv'
require 'pry'

class DistrictRepo
  include Parser
  include Validator

  attr_reader :districts

  def initialize
    @districts = Hash.new
  end

  def load_data(input_data)
    file = parse_kindergarten_enrollment_to_file(input_data)
    file_contents = CSV.open(file, headers: true, header_converters: :symbol)

    file_contents.each do |row|
      @districts[row[:location]] = District.new({:name => row[:location]})
    end

  end

  def find_by_name(name)
    @districts[name]
  end

  def find_all_matching(name_substring)
    all_matching = []
    length = validate_substring_length(name_substring)
    @districts.keys.each do |district|
      if length == 0
        all_matching << district if district[0] == name_substring.upcase
      else
        all_matching << district if district[0..length-1] == name_substring.upcase
      end
    end
    all_matching
  end

end
