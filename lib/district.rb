

class District

  attr_accessor :name,
                :enrollment

  def initialize(name_data)
    @name = name_data[:name].upcase
    @enrollment = enrollment
  end

end
