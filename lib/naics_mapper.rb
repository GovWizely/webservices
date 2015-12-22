require 'csv'

class NaicsMapper
  CSV_HEADERS = [:code_2007, :title_2007, :code_2012, :title_2012]

  def initialize
    options = {
      user_provided_headers: CSV_HEADERS,
      headers_in_file:       false,
    }
    @lookup_hash = SmarterCSV.process("#{Rails.root}/data/2012_to_2007_NAICS.csv", options)
  end

  def lookup_naics_code(code)
    result = search_for_code(code, :code_2012)
    if result
      return result[:title_2012]
    else
      result = search_for_code(code, :code_2007)
      if result
        return result[:title_2007]
      else
        fail 'NAICS code not found: ' + code
      end
    end
  end

  def search_for_code(code, key)
    @lookup_hash.find { |entry| entry[key] == code.to_i }
  end
end
