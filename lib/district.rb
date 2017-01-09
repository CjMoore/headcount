

class District

  attr_accessor :name,
                :enrollment,
                :statewide_test

  def initialize(name_data)
    @name = name_data[:name].upcase
    @enrollment = enrollment
    @statewide_test = statewide_test
  end

end
