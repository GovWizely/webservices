require 'csv'
module DataSourceParser
  TYPES = %w(string enum integer float date)
  PROBABLY_TOO_LONG_FOR_ENUM = 8

  def self.generate_dictionary(csv_string)
    dictionary = {}
    csv = CSV.parse(csv_string, converters: [:date, :numeric], headers: true)
    csv.headers.each do |header|
      sanitized_header = header.downcase.gsub(/\s+/, "_").gsub(/\W+/, "").to_sym
      column_values = csv.map { |r| r[header] }
      dictionary[sanitized_header] = { source: header,
                                         description: "Description of #{header}",
                                         type: guess_column_type_from_data(column_values) }

    end
    dictionary
  end

  def self.guess_column_type_from_data(column_values)
    column_values.compact!
    data_groups = column_values.group_by { |i| i.class }
    if data_groups[Float]
      'float'
    elsif data_groups[Fixnum]
      'integer'
    elsif data_groups[Date]
      'date'
    elsif data_groups[String]
      if column_values.collect(&:length).sum / column_values.size > PROBABLY_TOO_LONG_FOR_ENUM
        'string'
      else
        'enum'
      end
    end
  end
end
