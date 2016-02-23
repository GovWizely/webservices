class IdQuery < Query
  def initialize(id)
    super({})
    @ids = [id]
  end

  private

  def generate_query(json)
    json.query do
      json.filtered do
        json.filter do
          json.ids do
            json.values @ids
          end
        end
      end
    end
  end

  def generate_filter(_json)
  end

  def generate_aggregations(_json)
  end
end
