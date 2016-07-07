class CachedApiEndpoint
  def initialize(ttl)
    @ttl_in_seconds = parse_ttl(ttl)
  end

  private

  def cached_response_for(url_template, param)
    url = url_template.sub('ORIGINAL_VALUE', ParamEncoder.encode(param))
    cached_get(url)
  end

  def cached_get(url)
    Rails.cache.fetch(url, expires_in: @ttl_in_seconds) do
      Net::HTTP.get(URI.parse(url))
    end
  end

  def parse_ttl(ttl)
    ttl_in_seconds = 0
    if ttl.present?
      scalar, units = ttl.split
      ttl_in_seconds = scalar.to_i.send(units)
    end
    ttl_in_seconds.to_i
  end
end
