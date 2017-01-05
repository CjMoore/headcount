class Enrollment

  attr_reader :name,
              :kindergarten_data

  def initialize(input_data)
    @name = input_data[:name]
    @kindergarten_data = input_data[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    @kindergarten_data
  end

  def kindergarten_participation_in_year(year)
    @kindergarten_data[year]
  end


end
