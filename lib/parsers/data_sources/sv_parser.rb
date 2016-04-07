require 'csv'
class DataSources::SVParser
  include DataTypeGuesser
  SAMPLE_SIZE = 100

  def initialize(sv_string, col_sep)
    @sv_string = sample(sv_string)
    @col_sep = col_sep
  end

  def generate_dictionary
    dictionary = {}
    csv = CSV.parse(@sv_string, converters: [:date, :numeric], headers: true, col_sep: @col_sep)
    csv.headers.each do |header|
      sanitized_header = sanitize_header(header)
      column_values = csv.map { |r| r[header] }
      guessed_column_type = guess_column_type_from_data(column_values)
      dictionary[sanitized_header] = default_dictionary_metadata_hash(header, guessed_column_type) if guessed_column_type.present?
    end
    dictionary
  end

  def sample(sv_string)
    array = sv_string.chomp.lines.map(&:chomp)
    headers = array.shift
    array.sample(SAMPLE_SIZE).unshift(headers).join("\n")
  end
end
