require_relative 'district_repository'
require_relative 'exceptions'


class HeadcountAnalyst
  include Exceptions

  STATE = "COLORADO"

  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district, compare)
    (district_enroll_average(district)/compare_enroll_average(compare)).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, compare)
    trend = Hash.new
    years = get_years_kindergarten(district)
    years.each do |year|
      trend[year] = enrollment_data_average_in_year(year, district, compare)
    end
    trend
  end

  def kindergarten_participation_against_high_school_graduation(district)
    compare = {:against => STATE}
    kindergarten_participation_rate_variation(district, compare)/graduation_rate_variation(district)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(input)
    district = check_district_for_or_across(input)
    if district.is_a? String
      correlation_fall_in_range?(correlation_value(district))
    else
      check_all_correlation_values(district)
    end

  end

  def correlation_values_for_districts(districts)
    districts.map do |district|
      correlation_fall_in_range?(correlation_value(district))
    end
  end

  def calculate_positive_correlation(correlation_values)
    index = 0
    correlation_values.each do |value|
      if value == true
        index += 1
      end
    end
    index.to_f/correlation_values.count.to_f
  end

  def get_correlation_values_for_districts(districts)
    calculate_positive_correlation(correlation_values_for_districts(districts))
  end

  def check_all_correlation_values(districts)
    positive_percent = get_correlation_values_for_districts(districts)
    if positive_percent > 0.70
      true
    else
    end
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
    validate_na_data(get_participation_by_year(district))
  end

  def get_participation_by_year(district)
    districts[district].enrollment.kindergarten_participation_by_year
  end

  def validate_na_data(data_set)
    data_set.each do |key, value|
      if value.is_a? String
        data_set[key] = 0.00
      end
    end
  end

  def high_school_graduation_data(district)
    validate_na_data(districts[district].enrollment.graduation_rate_by_year)
  end

  def districts
    district_repo.districts
  end

  def enrollment_data_average(enrollment_data)
    (enrollment_data.values.reduce(:+))/enrollment_data.values.count
  end

  def graduation_data_average(grad_data)
    (grad_data.values.compact.reduce(:+))/grad_data.values.compact.count
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
      @district_repo.districts.keys[1..-1]
    else
      district[:for]
    end
  end

  def check_district_for_or_across(input_data)
    if input_data.keys.include?(:for)
      check_district_or_statewide(input_data)
    else
      input_data[:across]
    end
  end

  def top_statewide_test_year_over_year_growth(input)
    statewide_growth = Hash.new
    districts.keys.each do |district|
      statewide_growth[district]=get_calculated_growth(input,district).round(3)
    end
    give_growth_for_top_districts(organize_growth(statewide_growth), input)
  end

  def organize_growth(statewide_growth)
    statewide_growth = nix_colorado(statewide_growth)
    statewide_growth.sort_by {|key, value| -value}
  end


  def nix_colorado(statewide_growth)
    statewide_growth.delete_if {|key, value| key == STATE}
  end

  def give_growth_for_top_districts(statewide_growth, input)
    growth = Array.new
    statewide_growth.each { |key, value| growth << [key, value]}
    if input.keys.include?(:top)
      growth[0..input[:top]]
    else
      growth[0]
    end
  end

  def get_calculated_growth(input, district)
    calculate_statewide_growth(get_grade_data(input, district), input, district)
  end

  def get_proficiency_in_year(input, district, year)
    get_statwide_test(district).proficient_for_subject_by_grade_in_year(subject(input), grade(input), year)
  end

  def calculate_statewide_growth(grade_data, input, district)
    if input.keys.include?(:subject)
      years = get_valid_years(grade_data[input[:subject]])
      if years.count == 1 || years.nil? || years.empty?
        0.0
      else
        get_subtracted_proficiency(input, district, years)/(years[-1] -years[0])
      end
    else
      calculate_average_growth(grade_data, input, district)
    end
  end

  def calculate_average_growth(grade_data, input, district)
    to_be_averaged = []
    grade_data.keys.each do |subject|
      input[:subject] = subject
      check_sufficent_data(grade_data, input, district, to_be_averaged)
    end
    (to_be_averaged.reduce(:+))/3
  end

  def check_sufficent_data(grade_data, input, district, to_be_averaged)
    years = get_valid_years(grade_data[input[:subject]])
    if years.count ==1 || years.nil? || years.empty?
      to_be_averaged << 0.0
    else
      to_be_averaged << get_subtracted_proficiency(input, district, years)/(years[-1] - years[0])
      input.delete_if{|key, value| key == :subject}
    end
  end

  def get_valid_years(grade_data)
    years = []
    grade_data.each do |key, value|
      if value.class == Float && value != 0
        years << key
      end
    end
    years
  end

  def first_year(grade_data, input)
    by_subject(grade_data, input).keys.sort[0]
  end

  def last_year(grade_data, input)
    by_subject(grade_data, input).keys.sort[-1]
  end

  def get_subtracted_proficiency(input, district, years)
    proficiency(input,district,years[-1])-proficiency(input, district, years[0])
  end

  def get_sufficent_data_first_year(input, district, year)
    if proficiency(input, district, year) == 0
      get_sufficent_data_first_year(input, district, (year +1))
    else
      proficiency(input, district, year)
    end
  end

  def proficiency(input, district, year)
    if get_proficiency_in_year(input, district, year).is_a? Float
      get_proficiency_in_year(input, district, year)
    else
      0.0
    end
  end

  def get_grade_data(input, district)
    check_grade_and_subject_are_sufficient(input, district)
  end

  def check_grade_and_subject_are_sufficient(input, district)
    if input.keys.include?(:grade)
      check_which_grade(input, district)
    else
      raise Exceptions::InsufficientInformationError
    end
  end

  def check_which_grade(input, district)
    if grade(input) == 3
        third_grade_data(district)
    elsif grade(input) == 8
        eighth_grade_data(district)
    else
      raise UnknownDataError
    end
  end

  def grade(input)
    input[:grade]
  end

  def subject(input)
    input[:subject]
  end

  def get_statwide_test(district)
    districts[district].statewide_test
  end

  def third_grade_data(district)
    get_statwide_test(district).third_grade_data
  end

  def eighth_grade_data(district)
    get_statwide_test(district).eighth_grade_data
  end

  def by_subject(grade_data, input)
    grade_data[subject(input)]
  end

end
