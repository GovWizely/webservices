class AustralianTradeLeadQuery < Query
  def initialize(options)
    super options
    @q = options[:q] if options[:q].present?
    @sort = @q ? nil : 'id'
  end

  private

  def generate_query(json)
    json.query do
      generate_match(json, :description, @q)
    end if @q
  end

  def generate_filter(_json)
  end
end
