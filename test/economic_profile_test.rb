require 'minitest/autorun'
require 'minitest/pride'
require_relative '../../headcount/lib/economic_profile'

class EconomicProfileTest < MiniTest::Test

  def test_economi_profile_can_have_name
    input_data = {:name => "ACADEMY 20"}

    profile = EconomicProfile.new(input_data)

    assert_equal "ACADEMY 20", profile.name
  end

  def test_economic_profile_can_get_data
    input_data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }

    profile = EconomicProfile.new(input_data)
    median_expect = {[2005, 2009] => 50000, [2008, 2014] => 60000}
    poverty_expect = {2012 => 0.1845}
    lunch_expect = {2014 => {:percentage => 0.023, :total => 100}}
    title_i_expect = {2015 => 0.543}

    assert_equal median_expect, profile.median_income_data
    assert_equal poverty_expect, profile.children_poverty_data
    assert_equal lunch_expect, profile.lunch_data
    assert_equal title_i_expect, profile.title_i_data
  end

  def test_median_household_income_in_year
    input_data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }

    profile = EconomicProfile.new(input_data)

    assert_equal 50000, profile.median_household_income_in_year(2005)
  end

  def test_medium_household_income_average
    input_data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }

    profile = EconomicProfile.new(input_data)

    assert_equal 55000, profile.median_household_income_average
  end

  def test_children_in_poverty_in_year
    input_data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }

    profile = EconomicProfile.new(input_data)

    assert_in_delta 0.184, profile.children_in_poverty_in_year(2012), 0.005
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    input_data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }

    profile = EconomicProfile.new(input_data)

    assert_in_delta 0.023, profile.free_or_reduced_price_lunch_percentage_in_year(2014), 0.005
  end

  def test_free_or_reduced_price_lunch_number_in_year
    input_data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }

    profile = EconomicProfile.new(input_data)

    assert_equal 100, profile.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_title_i_in_year
    input_data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }

    profile = EconomicProfile.new(input_data)

    assert_in_delta 0.543, profile.title_i_in_year(2015), 0.005
  end

end
