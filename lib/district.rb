

class District

  attr_accessor :name,
                :enrollment,
                :statewide_test,
                :economic_profile

  def initialize(name_data)
    @name = name_data[:name].upcase
    @enrollment = enrollment
    @statewide_test = statewide_test
    @economic_profile = economic_profile
  end

end
