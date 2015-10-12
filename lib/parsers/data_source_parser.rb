require 'csv'
class DataSourceParser
  TYPES = %w(string enum integer float date)
  PROBABLY_TOO_LONG_FOR_ENUM = 8

  def initialize(csv_string)
    @csv_string = csv_string
  end

  def generate_dictionary
    dictionary = {}
    csv = CSV.parse(@csv_string, converters: [:date, :numeric], headers: true)
    csv.headers.each do |header|
      sanitized_header = sanitize_header(header)
      column_values = csv.map { |r| r[header] }
      guessed_column_type = guess_column_type_from_data(column_values)
      dictionary[sanitized_header] = { source:      header,
                                       description: "Description of #{header}",
                                       indexed:     true,
                                       type:        guessed_column_type } if guessed_column_type.present?
    end
    dictionary
  end

  private

  def guess_column_type_from_data(column_values)
    column_values.compact!
    data_groups = column_values.group_by(&:class)
    if data_groups[Float]
      'float'
    elsif data_groups[Fixnum]
      'integer'
    elsif data_groups[Date]
      'date'
    elsif data_groups[String]
      long_average_string_length?(column_values) ? 'string' : 'enum'
    end
  end

  def sanitize_header(header)
    header.downcase.gsub(/\s+/, '_').gsub(/\W+/, '').to_sym
  end

  def long_average_string_length?(column_values)
    column_values.collect(&:length).sum / column_values.size > PROBABLY_TOO_LONG_FOR_ENUM
  end
end
