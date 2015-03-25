class V2::MarketResearchQuery < CountryIndustryQuery
  def initialize(options = {})
    super
    @sort = @q ? nil : 'title.keyword'
    @industries = options[:industries].split(',').map(&:strip) rescue nil
    # Just to be sure, at this point, that no
    # filtering/sorting/scoring is being done on @industry
    @industry = nil
  end

  private

  def generate_query(json)
    json.query do
      json.bool do
        json.must do
          json.child! do
            generate_multi_match(json, %w(description title), @q)
          end if @q
        end
      end
    end if @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.countries @countries } } if @countries
          json.child! do
            json.bool do
              json.set! 'should' do
                Array(@industries).each do |ind|
                  json.child! do
                    json.query do
                      generate_multi_match(json, %w(industries.original.keyword industries.mapped.keyword), ind)
                    end
                  end
                end
              end
            end
          end if @industries
        end
      end
    end if @countries || @industries
  end
end
