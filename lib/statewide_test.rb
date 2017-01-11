require_relative 'data_parser'
require_relative 'exceptions'

class StatewideTest
  include DataParser
  include Exceptions

  SUBJECTS = [:math, :reading, :writing]
  RACES = [:asian, :black, :pacific_islander, :hispanic, :native_american,
            :two_or_more, :white]

  attr_reader :name,
              :third_grade_data,
              :eighth_grade_data,
              :math_data,
              :reading_data,
              :writing_data

  def initialize(input_data)
    @name = input_data[:name]
    @third_grade_data = input_data[:third_grade]
    @eighth_grade_data = input_data[:eighth_grade]
    @math_data = input_data[:math]
    @reading_data = input_data[:reading]
    @writing_data = input_data[:writing]
  end

  def proficient_by_grade(grade)
    parse_proficient_data(check_grade(grade))
  end

  def check_grade(grade)
    if grade == 3
      @third_grade_data
    elsif grade == 8
      @eighth_grade_data
    else
      raise Exceptions::UnknownDataError
    end
  end

  def proficient_by_race_or_ethnicity(race_ethnicity)
    check_race(race_ethnicity)
  end

  def check_race(race_ethnicity)
    if RACES.include?(race_ethnicity)
      race_ethnicity = race_ethnicity.to_s.capitalize
      get_data_by_race(race_ethnicity, race_data)
    else
      raise Exceptions::UnknownDataError
    end
  end

  def race_data
    race_data = Hash.new
    race_data[:math] = @math_data
    race_data[:reading]= @reading_data
    race_data[:writing] = @writing_data
    race_data
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if SUBJECTS.include?(subject)
      proficiency_given_subject_grade_year(check_grade(grade), subject, year)
    else
      raise Exceptions::UnknownDataError
    end
  end

  def proficiency_given_subject_grade_year(grade, subject, year)
    grade[subject][year]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    proficiency_given_subject_race_year(check_race(race), subject, year)
  end

  def proficiency_given_subject_race_year(data_by_race, subject, year)
    if SUBJECTS.include?(subject) && data_by_race
      data_by_race[year][subject]
    else
      raise Exceptions::UnknownDataError
    end
  end
end
