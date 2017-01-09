module DataParser

  def get_enrollment_data_by_district(file_contents)
    enrollment_by_district = Hash.new
    file_contents.each do |row|
      validate_enrollment_by_district(enrollment_by_district, row)
    end
    enrollment_by_district
  end

  def validate_enrollment_by_district(enrollment_by_district, row)
    if enrollment_by_district.keys.include?(location(row))
      enrollment_by_district[location(row)][time_frame(row)] = data(row)
    else
      enrollment_by_district[location(row)] = Hash.new
      enrollment_by_district[location(row)][time_frame(row)] = data(row)
    end
    enrollment_by_district
  end

  def validate_file(file)
    if file == nil
      []
    else
      file
    end
  end


end
