class DataSource < ActiveResource::Base
  self.site = Rails.configuration.endpointme_url

  def is_consolidated?
    self.consolidated.present? && self.consolidated.to_s == 'true'
  end

  def sources_map
    return {} unless self.is_consolidated? and self.dictionary.present?
    @sources_map ||= YAML.load(self.dictionary).collect do |e|
      data_source = DataSource.find([e['api'], e['version_number']].join(":v"))
      [e['source'], data_source] if data_source.present?
    end.compact.to_h
  end
end
