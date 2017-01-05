module Validator

  def validate_substring_length(name_substring)
    if name_substring.length == 1
      length = 0
    else
      length = name_substring.length
    end
    length
  end

end
