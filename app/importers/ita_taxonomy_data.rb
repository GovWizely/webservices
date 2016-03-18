require 'open-uri'
require 'zip'

class ItaTaxonomyData
  include Importable
  include VersionableResource

  def initialize(resource = nil)
    resource = Rails.configuration.protege_url if resource.nil?
    @parser = TaxonomyParser.new(resource)
  end

  def import
    @parser.parse
    ItaTaxonomy.index build_json_entries
  end

  def loaded_resource
    @parser.raw_source
  end

  private

  def build_json_entries
    entries = []
    @parser.concepts.each do |concept_hash|
      entry = concept_hash
      entry[:id] = Utils.generate_id(entry, %i(subject))

      entry[:query_expansion_terms] = is_country_term?(entry) ? add_geo_fields([entry[:label]]) : {}

      entries.push entry
    end
    entries
  end

  def is_country_term?(entry)
    entry[:object_properties].key?(:member_of) && entry[:object_properties][:member_of].map { |t| t[:label] }.include?('Countries')
  end
end
