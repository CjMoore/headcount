require_relative 'statewide_test'
require_relative 'parser'

class StatewideTestRepository

  include Parser

  attr_accessor :tests

  def initialize
    @tests = tests
  end

end
