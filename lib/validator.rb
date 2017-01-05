module Validator

  def validate_substring_length(name_substring)
    if name_substring.length == 1
      length = 0
    else
      length = name_substring.length
    end
    length
  end

  def validate_districts_contain_substring(district, name_substring)
    length = validate_substring_length(name_substring)
    if length == 0
      district if district[0] == name_substring.upcase
    else
      district if district[0..length-1] == name_substring.upcase
    end
  end

end
