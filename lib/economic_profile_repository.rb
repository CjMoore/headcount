require_relative 'economic_profile'
require_relative 'csv_parser'
require_relative 'data_parser'
require 'pry'

class EconomicProfileRepository
  include CsvParser
  include DataParser

  attr_reader :profiles

  def initialize
    @profiles = Hash.new
  end

  def load_data(input_data)
    all_files = parse_file_open_with_csv(input_data[:economic_profile])
    files = get_files_by_type(all_files)

    files.each do |key, value|
      files[key] = parse_economic_data_by_file(key, value)
    end
    make_economic_profiles(files)
  end

  def make_economic_profiles(files)
    districts = files[:title_i].keys
    districts.each do |district|
      @profiles[district] = EconomicProfile.new({:name => district,
                                                :median_household_income =>
                                                median_income(files)[district],
                                                :children_in_poverty =>
                                                child_poverty(files)[district],
                                                :free_or_reduced_price_lunch =>
                                                free_lunch(files)[district],
                                                title_i(files) =>
                                                files[:title_i][district]})
    end
  end

  def median_income(files)
    files[:median_household_income]
  end

  def child_poverty(files)
    files[:children_in_poverty]
  end

  def free_lunch(files)
    files[:free_or_reduced_price_lunch]
  end

  def title_i(files)
    files[:title_i]
  end

  def get_files_by_type(files)
    {:median_household_income => validate_file(files[0]),
      :children_in_poverty => validate_file(files[1]),
      :free_or_reduced_price_lunch => validate_file(files[2]),
      :title_i => validate_file(files[3])}
  end

  def find_by_name(name)
    @profiles[name]
  end

end
