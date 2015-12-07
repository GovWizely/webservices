class Hash
  def deep_stringify
    JSON.parse(to_json)
  end

  def include_hash?(other)
    self.merge(other) == self
  end
end
