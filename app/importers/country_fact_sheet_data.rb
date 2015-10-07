require 'open-uri'

class CountryFactSheetData
  include Importable
  include ::VersionableResource

  FIELDS = %w(id title site_url content_url content_html full_url full_html mobile_url date terms bureau official_name)
  ENDPOINT = "http://www.state.gov/api/v1/?command=get_country_fact_sheets&fields=#{FIELDS.join(',')}"

  def initialize(resource = ENDPOINT, options = {})
    @resource = resource
    @per_page = options[:per_page] || 10
  end

  def import
    fact_sheets = data.map { |fact_sheet_hash| process_fact_sheet_info(fact_sheet_hash) }
    CountryFactSheet.index(fact_sheets)
  end

  private

  def process_fact_sheet_info(fact_sheet_hash)
    fact_sheet = remap_keys COLUMN_HASH, fact_sheet_hash
    fact_sheet
  end

  def data
    page = 0
    results = []
    loop do
      response = JSON.parse(open("#{ENDPOINT}&per_page=#{@per_page}&page=#{page}").read)
      results.concat(response['country_fact_sheets'])
      break if last_page?(page, response['pages'])
      page += 1
    end
    results
  end

  def last_page?(current_page, total_page)
    (current_page + 1) == total_page.to_i
  end
end
