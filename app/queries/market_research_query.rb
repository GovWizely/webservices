class MarketResearchQuery < CountryIndustryQuery
  def initialize(options = {})
    super
    @sort = @q ? nil : 'title.keyword'
    @industry ||= options[:industries].try{|o| o.split(',').map(&:strip) }
    @countries &&= @countries.try{|c| c.join(' ')}
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
          json.child! { json.query { json.match { json.countries @countries } } } if @countries
          Array(@industry).each{ |ind|
            json.child! {
              json.query {
                generate_multi_match(json, %w(industries.original industries.mapped), ind)
              }
            }
          }
        end
      end
    end if @countries or @industry
  end
end
