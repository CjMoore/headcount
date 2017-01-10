

class EconomicProfile

  def initialize(input_data)
    @median_income_data = input_data[:median_household_income]
    @children_poverty_data = input_data[:children_in_poverty]
    @lunch_data = input_data[:free_or_reduced_price_lunch]
    @title_i_data = input_data[:title_i]
    @name = input_data[:name]
  end

  

end
