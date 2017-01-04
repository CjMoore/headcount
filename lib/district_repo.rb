require_relative 'district'
require_relative 'parser'
require 'csv'
require 'pry'

class DistrictRepo
  include Parser

  attr_reader :districts

  def initialize
    @districts = Hash.new
  end

  def load_data(input_data)
    file = parse_kindergarten_enrollment_to_file(input_data)
    binding.pry
    file_contents = CSV.open file, headers: true, header_converters: :symbol

    file.each do |row|
      @districts << District.new({:name => (row[:location].upcase)})
    end

  end

  # def make_district(row)
  #   district = District.new({:name => row[:location]})
  # end

end
