require 'csv'

module Parser

  def parse_kindergarten_enrollment_to_file(input_data)
    file = input_data[:enrollment][:kindergarten]
    file
  end

  def parse_file_open_with_csv(input_data)
    file = parse_kindergarten_enrollment_to_file(input_data)
    file_contents = CSV.open(file, headers: true, header_converters: :symbol)
  end

end
