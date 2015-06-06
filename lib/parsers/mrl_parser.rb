require 'open-uri'

class MrlParser
  COLUMN_SEPARATOR = '<MRL_COL_END>'.freeze
  ROW_SEPARATOR = '<MRL_ROW_END>'.freeze

  attr_reader :headers

  def initialize(header_row)
    @headers = extract_headers header_row
  end

  def self.foreach(resource, &block)
    parser = nil
    resource.split(ROW_SEPARATOR).each do |mrl_row|
      stripped_row = mrl_row.strip
      next if stripped_row.blank?

      if parser.nil?
        parser = MrlParser.new(stripped_row)
      else
        parser.each(stripped_row, &block)
      end
    end
  end

  def each(row)
    values = extract_values row
    yield convert_values_to_hash(values)
  end

  private

  def extract_headers(header_row)
    extract_values(header_row).map(&:to_sym)
  end

  def extract_values(row)
    sanitized_row = row.gsub(/#{ROW_SEPARATOR}$/, '')
    sanitized_row.split(COLUMN_SEPARATOR)
  end

  def convert_values_to_hash(values)
    hash = {}
    @headers.each_with_index do |column, index|
      value = values[index].present? ? values[index].squish : nil
      hash[column] = value
    end
    hash
  end
end
