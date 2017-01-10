require_relative 'exceptions'

class EconomicProfile
  include Exceptions

  attr_reader :name,
              :median_income_data,
              :children_poverty_data,
              :lunch_data,
              :title_i_data

  def initialize(input_data)
    @median_income_data = input_data[:median_household_income]
    @children_poverty_data = input_data[:children_in_poverty]
    @lunch_data = input_data[:free_or_reduced_price_lunch]
    @title_i_data = input_data[:title_i]
    @name = input_data[:name]
  end

  def median_household_income_in_year(year)
    income = 0
    @median_income_data.keys.each do |years|
      if years.include?(year)
        income = @median_income_data[years]
      else
        # raise Exceptions::UnknownDataError
      end
    end
    income
  end

  def median_household_income_average
    (@median_income_data.values.reduce(:+))/@median_income_data.values.count
  end

  def children_in_poverty_in_year(year)
    if check_if_given_year_is_included?(children_poverty_data, year)
      @children_poverty_data[year]
    end
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if check_if_given_year_is_included?(lunch_data, year)
      @lunch_data[year][:percentage]
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    if check_if_given_year_is_included?(lunch_data, year)
      @lunch_data[year][:total]
    end
  end

  def title_i_in_year(year)
    if check_if_given_year_is_included?(title_i_data, year)
      @title_i_data[year]
    end
  end

  def check_if_given_year_is_included?(data, year)
    if data.keys.include?(year)
      true
    else
      raise Exceptions::UnknownDataError
    end
  end




end
