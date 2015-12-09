class Hash
  def deep_stringify
    JSON.parse(to_json)
  end

  def include_hash?(other)
    merge(other) == self
  end
end
