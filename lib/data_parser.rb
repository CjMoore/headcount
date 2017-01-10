require_relative 'csv_parser'
require 'pry'

module DataParser
  include CsvParser

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

  def get_statewide_testing_data_by_file(key, value)
    data_by_district = Hash.new
    value.each do |row|
      key2 = check_grade_or_race_data(key, row)
      check_location_in_data_by_district(data_by_district, row, key2)
    end
    data_by_district
  end

  def check_location_in_data_by_district(data_by_district, row, key2)
    if data_by_district.keys.include?(location(row))
      check_location_points_to_hash(data_by_district, row, key2)
    else
      make_nested_hashes_for_data_by_district(data_by_district, row, key2)
    end
  end

  def check_location_points_to_hash(data_by_district, row, key2)
    if data_by_district[location(row)].is_a? Hash
      check_key2_in_data_by_district(data_by_district, row, key2)
    else
      make_nested_hashes_for_data_by_district(data_by_district, row, key2)
    end
  end

  def check_key2_in_data_by_district(data_by_district, row, key2)
    if data_by_district[location(row)].keys.include?(key2)
      data_by_district[location(row)][key2][time_frame(row)] = data(row)
    else
      data_by_district[location(row)][key2] = Hash.new
      data_by_district[location(row)][key2][time_frame(row)]= data(row)
    end
  end

  def make_nested_hashes_for_data_by_district(data_by_district, row, key2)
    data_by_district[location(row)] = Hash.new
    data_by_district[location(row)][key2] = Hash.new
    data_by_district[location(row)][key2][time_frame(row)] = data(row)
  end

  def check_grade_or_race_data(key, row)
    if key == :third_grade || key == :eighth_grade
      score(row)
    else
      race(row)
    end
  end

  def parse_proficient_data(grade_data)
    sorted_grade_data = Hash.new
    years = grade_data[:math].keys
    # binding.pry
    years.each do |year|
      sorted_grade_data[year] = {:math => grade_data[:math][year],
                                  :reading => grade_data[:reading][year],
                                  :writing => grade_data[:writing][year]}
    end
    sorted_grade_data
  end

  def get_data_by_race(race, race_data)
    data_by_race = Hash.new
    years = race_data[:math][race].keys
    # binding.pry
    years.each do |year|
      data_by_race[year] = {:math => race_data[:math][race][year],
                            :reading => race_data[:reading][race][year],
                            :writing => race_data[:writing][race][year]}
    end
    data_by_race
  end



  def validate_file(file)
    if file == nil
      []
    else
      file
    end
  end


end
