class SemanticQueryService < CachedApiEndpoint
  def initialize(options)
    @url_template = options[:url]
    super(options[:ttl])
  end

  def parse(q)
    json = JSON.parse(cached_response_for(@url_template, q))
    Hashie::Mash.new(json.to_h)
  end
end
