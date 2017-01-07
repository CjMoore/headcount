require 'csv'

module Parser

  def parse_kindergarten_enrollment_to_file(input_data)
    file = input_data[:enrollment][:kindergarten]
    file
  end

  def parse_high_school_graduation_to_file(input_data)
    file = input_data[:enrollment][:high_school_graduation]
    file
  end

  def parse_file_open_with_csv(input_data)
    # binding.pry
    files = [parse_kindergarten_enrollment_to_file(input_data),
              parse_high_school_graduation_to_file(input_data)]
    files.map do |file|
      CSV.open(file, headers: true, header_converters: :symbol) unless file.nil?
    end
  end

  def location(row)
    row[:location].upcase
  end

  def time_frame(row)
    row[:timeframe].to_i
  end

  def data(row)
    (row[:data])[0..4].to_f
  end

end
