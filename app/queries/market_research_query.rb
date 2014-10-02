class MarketResearchQuery < CountryIndustryQuery
  def initialize(options)
    super
    @sort = @q ? nil : 'title.keyword'
  end

  private

  def generate_query(json)
    generate_multi_query json, [:description, :title]
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.countries @countries } }
        end
      end
    end if @countries
  end
end
