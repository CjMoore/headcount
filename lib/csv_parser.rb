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
    end
  end

  def get_enrollment_files(input_data)
    files = [input_data[:kindergarten], input_data[:high_school_graduation]]
  end

  def get_testing_files(input_data)
    files = [input_data[:third_grade], input_data[:eighth_grade],
              input_data[:math], input_data[:reading], input_data[:writing]]
  end

  def location(row)
    row[:location].upcase
  end

  def time_frame(row)
    row[:timeframe].to_i
  end

  def data(row)
    unless row[:data].nil?
      if row[:data] == "N/A"
        row[:data]
      else
        (row[:data])[0..4].to_f
      end
    end
  end

  def score(row)
    (row[:score].downcase.to_sym)
  end

  def race(row)
    (row[:race_ethnicity].capitalize)
  end

end
