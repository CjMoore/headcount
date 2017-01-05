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
    file_contents = parse_file_open_with_csv(input_data)
    file_contents.each do |row|
      @districts[row[:location]] = District.new({:name => row[:location]})
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
