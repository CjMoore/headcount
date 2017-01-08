require_relative 'district_repository'

class HeadcountAnalyst

  STATE = "COLORADO"

  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district, compare)
    (district_enroll_average(district)/compare_enroll_average(compare)).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, compare)
    rate_variation_trend = Hash.new
    years = get_years_kindergarten(district)
    years.each do |year|
      rate_variation_trend[year] = enrollment_data_average_in_year(year, district, compare)
    end
    rate_variation_trend
  end

  def kindergarten_participation_against_high_school_graduation(district)
    compare = {:against => STATE}
    kindergarten_participation_rate_variation(district, compare)/graduation_rate_variation(district)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    district_name = district[:for]
    correlation_fall_in_range?(correlation_value(district_name))
  end

  def correlation_value(district)
    kindergarten_participation_against_high_school_graduation(district)
  end

  def correlation_fall_in_range?(correlation_value)
    if correlation_value > 0.6 && correlation_value < 1.5
      true
    else
      false
    end
  end

  def graduation_rate_variation(district)
    (district_grad_average(district)/state_grad_average)
  end

  def kindergarten_enrollment_data(district)
    @district_repo.districts[district].enrollment.kindergarten_participation_by_year
  end

  def high_school_graduation_data(district)
    @district_repo.districts[district].enrollment.graduation_rate_by_year
  end

  def enrollment_data_average(enrollment_data)
    (enrollment_data.values.reduce(:+))/enrollment_data.values.count
  end

  def graduation_data_average(graduation_data)
    (graduation_data.values.compact.reduce(:+))/graduation_data.values.compact.count
  end

  def get_graduation_data_average(district)
    graduation_data_average(high_school_graduation_data(district))
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

  def district_enroll_average(district)
    get_enrollment_data_average(district)
  end

  def compare_enroll_average(compare)
    get_enrollment_data_average(compare[:against])
  end

  def district_grad_average(district)
    get_graduation_data_average(district)
  end

  def state_grad_average
    get_graduation_data_average(STATE)
  end

  def check_district_or_statewide(district)
    if district[:for] == "STATEWIDE"
      @district_repo.districts.keys
    else
      district[:for]
    end
  end
end
