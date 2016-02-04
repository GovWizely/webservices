module HTMLEntityUtils
  def sanitize_entry(entry)
    @html_entities_coder ||= HTMLEntities.new
    entry.each do |k, v|
      next unless v.is_a?(String)
      entry[k] = v.present? ? @html_entities_coder.decode(Sanitize.clean(v)).squish : nil
    end
    entry
  end
end
