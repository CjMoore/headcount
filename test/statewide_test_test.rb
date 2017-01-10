# require 'simplecov'
# SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/statewide_test'
require './lib/exceptions'

class StatewideTestTest < MiniTest::Test
  include Exceptions

  def test_statewide_test_can_take_name
    input_data = {:name => "ACADEMY 20"}

    statewide_test = StatewideTest.new(input_data)

    assert_equal "ACADEMY 20", statewide_test.name
  end

  def test_statewide_test_can_take_data
    input_data = {:third_grade => {:math => {2010 => 0.987},
                                  :reading => {2010 => 0.987},
                                  :writing => {2010 => 0.987}},
                  :eighth_grade => {:math => {2010 => 0.987},
                                    :reading => {2010 => 0.987},
                                    :writing => {2010 => 0.987}},
                  :math => {:all_races => {2010 => 0.987}},
                  :reading => {:all_races => {2010 => 0.987}},
                  :writing => {:all_races => {2010 => 0.987}}}

    statewide = StatewideTest.new(input_data)

    grade_expected = {:math => {2010 => 0.987},
                      :reading => {2010 => 0.987},
                      :writing => {2010 => 0.987}}
    subject_expected = {:all_races => {2010 => 0.987}}

    assert_equal grade_expected, statewide.third_grade_data
    assert_equal grade_expected, statewide.eighth_grade_data
    assert_equal subject_expected, statewide.math_data
    assert_equal subject_expected, statewide.reading_data
    assert_equal subject_expected, statewide.writing_data
  end

  def test_proficent_by_grade_gives_correct_data
    input_data = {:third_grade => {:math => {2010 => 0.987, 2011 => 0.123},
                                  :reading => {2010 => 0.987, 2011 => 0.123},
                                  :writing => {2010 => 0.987, 2011 =>0.123}},
                  :eighth_grade => {:math => {2010 => 0.987, 2011 => 0.123},
                                    :reading => {2010 => 0.987, 2011 => 0.123},
                                    :writing => {2010 => 0.987, 2011 => 0.123}}}
    statewide = StatewideTest.new(input_data)

    expected = {2010 => {:math => 0.987,
                          :reading=> 0.987,
                          :writing => 0.987},
                  2011 => {:math => 0.123,
                          :reading=> 0.123,
                          :writing => 0.123}}

    assert_equal expected, statewide.proficient_by_grade(3)
  end

  def test_statewide_test_can_check_grade
    input_data = {:third_grade => {:math => {2010 => 0.987},
                                  :reading => {2010 => 0.987},
                                  :writing => {2010 => 0.987}},
                  :eighth_grade => {:math => {2010 => 0.987},
                                  :reading => {2010 => 0.987},
                                  :writing => {2010 => 0.987}}}

    statewide = StatewideTest.new(input_data)

    assert_equal statewide.third_grade_data, statewide.check_grade(3)
    assert_equal statewide.eighth_grade_data, statewide.check_grade(8)
  end

  def test_proficient_by_race_or_ethnicity_returns_correct_data
    input_data = {:math =>
                    {"All students"=>{2011=>0.68, 2012=>0.689},
                    "Asian"=>{2011=>0.816, 2012=>0.818},
                    "Black"=>{2011=>0.424, 2012=>0.424}},
                  :reading =>
                    {"All students"=>{2011=>0.83, 2012=>0.845},
                    "Asian"=>{2011=>0.897, 2012=>0.893},
                    "Black"=>{2011=>0.662, 2012=>0.694}},
                  :writing =>
                    {"All students"=>{2011=>0.719, 2012=>0.705},
                    "Asian"=>{2011=>0.826, 2012=>0.808},
                    "Black"=>{2011=>0.515, 2012=>0.504}}}

    statewide = StatewideTest.new(input_data)
    expected = {2011 => {:math => 0.816, :reading => 0.897, :writing => 0.826},
                2012 => {:math => 0.818, :reading => 0.893, :writing => 0.808}}

    assert_equal expected, statewide.proficient_by_race_or_ethnicity(:asian)
  end

  def test_proficient_for_subject_by_grade_in_year
    input_data = {:third_grade => {:math => {2010 => 0.987, 2011 => 0.123},
                                  :reading => {2010 => 0.987, 2011 => 0.123},
                                  :writing => {2010 => 0.987, 2011 =>0.123}},
                  :eighth_grade => {:math => {2010 => 0.987, 2011 => 0.123},
                                    :reading => {2010 => 0.987, 2011 => 0.123},
                                    :writing => {2010 => 0.987, 2011 => 0.123}}}
    statewide = StatewideTest.new(input_data)

    assert_equal 0.987, statewide.proficient_for_subject_by_grade_in_year(:math, 3, 2010)
  end

  def test_proficient_for_subject_by_race_in_year
    input_data = {:math =>
                    {"All students"=>{2011=>0.68, 2012=>0.689},
                    "Asian"=>{2011=>0.816, 2012=>0.818},
                    "Black"=>{2011=>0.424, 2012=>0.424}},
                  :reading =>
                    {"All students"=>{2011=>0.83, 2012=>0.845},
                    "Asian"=>{2011=>0.897, 2012=>0.893},
                    "Black"=>{2011=>0.662, 2012=>0.694}},
                  :writing =>
                    {"All students"=>{2011=>0.719, 2012=>0.705},
                    "Asian"=>{2011=>0.826, 2012=>0.808},
                    "Black"=>{2011=>0.515, 2012=>0.504}}}

    statewide = StatewideTest.new(input_data)

    assert_equal 0.662, statewide.proficient_for_subject_by_race_in_year(:reading, :black, 2011)
  end

  def test_bad_input_raises_error
    input_data = {:third_grade => {:math => {2010 => 0.987, 2011 => 0.123},
                                  :reading => {2010 => 0.987, 2011 => 0.123},
                                  :writing => {2010 => 0.987, 2011 =>0.123}},
                  :eighth_grade => {:math => {2010 => 0.987, 2011 => 0.123},
                                    :reading => {2010 => 0.987, 2011 => 0.123},
                                    :writing => {2010 => 0.987, 2011 => 0.123}}}

    statewide = StatewideTest.new(input_data)

    assert_raises(UnknownDataError) do
      statewide.proficient_for_subject_by_grade_in_year(:pizza, 8, 2011)
    end
  end
end
