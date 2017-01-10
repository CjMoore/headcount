require 'csv'

module CsvParser

  def parse_file_open_with_csv(input_data)
    files = check_enrollment_testing_or_economic_files(input_data)
    files.map do |file|
      CSV.open(file, headers: true, header_converters: :symbol) unless file.nil?
    end
  end

  def check_enrollment_testing_or_economic_files(input_data)
    if input_data.keys.include?(:kindergarten)
      get_enrollment_files(input_data)
    elsif input_data.keys.include?(:third_grade)
      get_testing_files(input_data)
    elsif input_data.keys.include?(:title_i)
      get_economic_files(input_data)
    end
  end

  def get_enrollment_files(input_data)
    files = [input_data[:kindergarten], input_data[:high_school_graduation]]
  end

  def get_testing_files(input_data)
    files = [input_data[:third_grade], input_data[:eighth_grade],
              input_data[:math], input_data[:reading], input_data[:writing]]
  end

  def get_economic_files(input_data)
    files = [input_data[:median_household_income],
              input_data[:children_in_poverty],
              input_data[:free_or_reduced_price_lunch],
              input_data[:title_i]]

  end

  def location(row)
    row[:location].upcase
  end

  def time_frame(row)
    if row[:dataformat] == "Currency"
      time_frame = row[:timeframe].split('-')
      time_frame.map {|year| year.to_i}
    else
      row[:timeframe].to_i
    end
  end

  def data(row)
    unless row[:data].nil?
      if row[:dataformat] == "Percent"
        if row[:data] == "N/A"
          row[:data]
        else
          (row[:data])[0..4].to_f
        end
      elsif row[:dataformat] == 'Currency' || 'Number'
        row[:data].to_i
      end
    end
  end

  def score(row)
    (row[:score].downcase.to_sym)
  end

  def race(row)
    (row[:race_ethnicity].capitalize)
  end

  def poverty_level(row)
    row[:poverty_level].downcase
  end

  def data_format(row)
    row[:dataformat].downcase.to_sym
  end

end
