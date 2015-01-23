class MarketResearchQuery < CountryIndustryQuery
  def initialize(options = {})
    super
    @sort = @q ? nil : 'title.keyword'
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
            json.nested do
              json.path 'industries'
              json.query do
                generate_multi_match(json, %w(industries.original industries.mapped), @industry)
              end
            end
          end if @industry
        end
      end
    end if @industry || @q
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
