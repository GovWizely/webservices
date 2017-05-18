class DataSource < ActiveResource::Base
  self.site = Rails.configuration.endpointme_url
  self.timeout = 3600

  def is_consolidated?
    consolidated.present? && consolidated.to_s == 'true'
  end

  def sources_map
    return {} unless is_consolidated? && dictionary.present?
    @sources_map ||= YAML.load(dictionary).collect do |e|
      data_source = DataSource.find([e['api'], e['version_number']].join(':v'))
      [e['source'], data_source] if data_source.present?
    end.compact.to_h
  end
end
