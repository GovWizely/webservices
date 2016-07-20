class IdsQuery
  attr_reader :offset

  def initialize(ids)
    @ids = ids
    @offset = 0
  end

  def generate_search_body_hash
    Jbuilder.new do |json|
      json.query do
        json.ids do
          json.values @ids
        end
      end
    end.attributes!
  end
end
