module HTMLEntityUtils
  def sanitize_entry(entry)
    entry.each do |k, v|
      next unless v.is_a?(String)
      entry[k] = v.present? ? sanitize_value(v) : nil
    end
    entry
  end

  def sanitize_value(v, flavor = 'xhtml1')
    html_entities_coder = HTMLEntities.new(flavor)
    html_entities_coder.decode(Sanitize.clean(v)).squish
  end
end
