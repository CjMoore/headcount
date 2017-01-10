require_relative 'economic_profile'
require_relative 'csv_parser'
require_relative 'data_parser'
require 'pry'

class EconomicProfileRepository
  include CsvParser
  include DataParser

  def initialize
    @profiles = Hash.new
  end
  
end
