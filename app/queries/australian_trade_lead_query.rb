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

  def generate_match(json, field, query, operator = :and)
    json.match do
      json.set! field do
        json.operator operator
        json.query query
      end
    end
  end

  def generate_filter(json)
  end
end
