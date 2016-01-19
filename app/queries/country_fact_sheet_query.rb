class CountryFactSheetQuery < CountriesTopicsQuery
  def initialize(options = {})
    super
    @sources = options[:sources].downcase.split(',') if options[:sources].present?
    @multi_fields = %i(title content_html)
    @field_mapping = { country: @countries, source: @sources, topic: @topics }
  end
end
