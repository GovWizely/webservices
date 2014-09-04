class TradeLeadQuery < Query
  attr_reader :countries, :sort

  def initialize(options)
    super options
    @q = options[:q] if options[:q].present?
    @countries = options[:countries].upcase.split(',') if options[:countries].present?
    @sort =  'publish_date:desc,country:asc' unless @q
  end

  private

  def generate_query(json)
    json.query do
      generate_multi_match(json, [:description, :title], @q)
    end if @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.country @countries } } if @countries
        end
      end
    end if @countries
  end
end
