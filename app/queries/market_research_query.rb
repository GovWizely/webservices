class MarketResearchQuery < CountryIndustryQuery
  def initialize(options = {})
    super
    @sort = @q ? nil : 'title.keyword'
    @expiration_date = options[:expiration_date] if options[:expiration_date].present?
  end

  private

  def generate_query(json)
    json.query do
      json.bool do
        json.must do
          json.child! do
            generate_multi_match(json, %w(description title), @q)
          end if @q
          json.child! do
            generate_multi_match(json, %w(industries.tokenized ita_industries.tokenized), @industry)
          end if @industry
        end
      end
    end if @industry || @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.countries @countries } } if @countries
          generate_date_range(json, 'expiration_date', @expiration_date) if @expiration_date
        end
      end
    end if @countries || @expiration_date
  end
end
