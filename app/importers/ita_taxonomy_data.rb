require 'open-uri'
require 'zip'

class ItaTaxonomyData
  include Importable
  include VersionableResource

  def initialize(resource = nil, pre_loaded_terms = nil)
    resource = Rails.configuration.protege_url if resource.nil?
    @taxonomy_parser = TaxonomyParser.new(resource, pre_loaded_terms)
  end

  def import
    @taxonomy_parser.parse if @taxonomy_parser.terms.empty?
    ItaTaxonomy.index build_json_entries
  end

  def loaded_resource
    @taxonomy_parser.raw_source
  end

  private

  def build_json_entries
    processed_entries = []
    taxonomy_terms = @taxonomy_parser.terms

    taxonomy_terms.each do |entry|
      process_entry(entry)
      processed_entries.push entry
    end
    processed_entries
  end

  def process_entry(entry)
    process_ids(entry)
    entry[:type] = get_concept_groups(entry)
    entry[:related_terms] = entry[:type].include?('Countries') ? add_geo_fields([entry[:label]]) : {}
  end

  def process_ids(entry)
    trim_id(entry[:subject])
    entry[:sub_class_of].each do |hash|
      trim_id(hash[:id])
    end
    entry[:object_properties].each do |_key, array|
      array.each do |hash|
        trim_id(hash[:id])
      end
    end
    entry[:id] = entry[:subject]
    entry.delete(:subject)
  end

  def trim_id(id)
    id.slice!('http://webprotege.stanford.edu/')
  end

  def get_concept_groups(entry)
    if entry[:object_properties].key?(:member_of)
      entry[:object_properties][:member_of].map { |t| t[:label] }
    else
      []
    end
  end
end
