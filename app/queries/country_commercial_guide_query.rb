class CountryCommercialGuideQuery < CountriesTopicsQuery
  def initialize(options = {})
    super
    @industries = options[:industries].downcase.split(',') if options[:industries].present?
    @multi_fields = %i(pdf_title pdf_chapter pdf_section content)
    @field_mapping = {country: @countries, topic: @topics, industry: @industries}
  end
end
