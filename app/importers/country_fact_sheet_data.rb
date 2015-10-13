require 'open-uri'

class CountryFactSheetData
  include Importable
  include ::VersionableResource

  COLUMN_HASH = {
    'id'           => :id,
    'title'        => :title,
    'content_html' => :content_html,
    'date'         => :published_date,
  }.freeze

  FIELDS = %w(id title content_html date terms bureau)
  ENDPOINT = "http://www.state.gov/api/v1/?command=get_country_fact_sheets&fields=#{FIELDS.join(',')}"

  def initialize(resource = ENDPOINT, options = {})
    @resource = resource
    @per_page = options[:per_page] || 5
  end

  def loaded_resource
    @loaded_resource ||= data.to_s
  end

  def import
    fact_sheets = data.map { |fact_sheet_hash| process_fact_sheet_info(fact_sheet_hash) }
    CountryFactSheet.index(fact_sheets)
  end

  private

  def process_fact_sheet_info(fact_sheet_hash)
    fact_sheet = remap_keys(COLUMN_HASH, fact_sheet_hash)
    fact_sheet[:topic] = ['Foreign Relations']
    fact_sheet[:source] = model_class.source[:code]
    fact_sheet[:country] = fact_sheet_hash['terms'].map do |term|
      lookup_country(term)
    end.compact
    fact_sheet[:country].push('US').uniq!
    fact_sheet
  end

  def data
    page = 0
    @results ||= []
    loop do
      response = JSON.parse(open(uri(page)).read)
      @results.concat(response['country_fact_sheets'])
      page += 1
      break if last_page?(page, response['pages'])
    end if @results.empty?
    @results
  end

  def uri(page)
    if @resource =~ URI.regexp
      "#{@resource}&per_page=#{@per_page}&page=#{page}"
    else
      @resource
    end
  end

  def last_page?(current_page, total_page)
    current_page >= total_page.to_i
  end
end
