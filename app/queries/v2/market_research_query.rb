class V2::MarketResearchQuery < CountryIndustryQuery
  def initialize(options = {})
    super
    @sort = @q ? nil : 'title.keyword'

    @industries = options[:industries].split(',').map(&:strip) if options[:industries].present?

    @expiration_date = options[:expiration_date] if options[:expiration_date].present?
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
          generate_date_range(json, 'expiration_date', @expiration_date) if @expiration_date
          generate_industries_bool(json, @industries) if @industries
        end
      end
    end if [@countries, @industries, @expiration_date].any?
  end

  def generate_industries_bool(json, industries)
    json.child! do
      json.bool do
        json.set! 'should' do
          Array(industries).each do |industry|
            json.child! do
              json.query do
                generate_multi_match(json, %w(industries.mapped.keyword), industry)
              end
            end
          end
        end
      end
    end
  end
end
