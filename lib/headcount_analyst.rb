require_relative 'district_repository'

class HeadcountAnalyst

  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district, compare)
    (district_average(district)/compare_average(compare)).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, compare)
    rate_variation_trend = Hash.new
    years = get_years_kindergarten(district)
    years.each do |year|
      rate_variation_trend[year] = enrollment_data_average_in_year(year, district, compare)
    end
    rate_variation_trend
  end

  def kindergarten_enrollment_data(district)
    @district_repo.districts[district].enrollment.kindergarten_participation_by_year
  end

  def enrollment_data_average(enrollment_data)
    (enrollment_data.values.reduce(:+))/enrollment_data.values.count
  end

  def get_enrollment_data_average(district)
    enrollment_data_average(kindergarten_enrollment_data(district))
  end

  def enrollment_data_in_year(year, district)
    (kindergarten_enrollment_data(district)[year]).round(3)
  end

  def get_years_kindergarten(district)
    kindergarten_enrollment_data(district).keys
  end

  def enrollment_data_average_in_year(year, district, compare)
    (enrollment_data_in_year(year, district)/enrollment_data_in_year(year, compare[:against])).round(3)
  end

  def district_average(district)
    get_enrollment_data_average(district)
  end

  def compare_average(compare)
    get_enrollment_data_average(compare[:against])
  end

end
