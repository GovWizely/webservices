class CountryIndustryQuery < Query
  attr_reader :countries

  def initialize(options = {})
    super
    @countries = begin
                   options[:countries].upcase.split(',').map(&:strip)
                 rescue
                   nil
                 end
    @industry = options[:industry]
    @q = options[:q].downcase if options[:q].present?
  end
end
