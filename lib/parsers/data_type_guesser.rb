module DataTypeGuesser
  PROBABLY_TOO_LONG_FOR_ENUM = 8
  PROBABLY_TOO_BIG_FOR_NUMERIC = 2**31

  def guess_column_type_from_data(column_values)
    column_values.compact!
    data_groups = column_values.group_by(&:class)
    if data_groups[Float]
      numbers_seem_reasonable?(column_values) ? 'float' : 'enum'
    elsif data_groups[Fixnum]
      numbers_seem_reasonable?(column_values) ? 'integer' : 'enum'
    elsif data_groups[Date]
      'date'
    elsif data_groups[String]
      long_average_string_length?(column_values) ? 'string' : 'enum'
    end
  end

  private

  def long_average_string_length?(column_values)
    column_values.collect(&:length).sum / column_values.size > PROBABLY_TOO_LONG_FOR_ENUM
  end

  def numbers_seem_reasonable?(column_values)
    column_values.max < PROBABLY_TOO_BIG_FOR_NUMERIC
  rescue ArgumentError
    false
  end

  def sanitize_header(header)
    header.downcase.gsub(/\s+/, '_').gsub(/\W+/, '').to_sym
  end

  def default_dictionary_metadata_hash(field_name, guessed_column_type)
    { source:      field_name,
      description: "Description of #{field_name}",
      indexed:     true,
      plural:      false,
      type:        guessed_column_type, }
  end
end
