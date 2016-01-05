require 'open-uri'
require 'zip'

class ItaTaxonomyData
  include Importable
  include VersionableResource

  COLUMN_HASH = {
    subject:        :id,
    label:          :name,
    path:           :path,
    concept_groups: :taxonomies,
    broader_terms:  :broader_terms,
    narrower_terms: :narrower_terms,
  }.freeze

  def initialize(resource = nil)
    @parser = resource.nil? ? TaxonomyParser.new : TaxonomyParser.new(resource)
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
      entry = remap_keys(COLUMN_HASH, concept_hash)
      entry[:id] = Utils.generate_id(entry, %i(id))
      entries.push entry
    end
    entries
  end
end
