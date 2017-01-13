class IdQuery < Query
  def initialize(id)
    super({})
    @ids = [id]
  end

  private

  def generate_query_and_filter(json)
    json.query do
      json.bool do
        json.filter do
          json.ids do
            json.values @ids
          end
        end
      end
    end
  end

  def generate_aggregations(_json)
  end
end
