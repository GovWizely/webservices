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
    processed_entries = []
    taxonomy_terms = @parser.concepts + @parser.concept_groups + @parser.concept_schemes

    taxonomy_terms.each do |entry|
      process_entry(entry)
      processed_entries.push entry
    end
    processed_entries
  end

  def process_entry(entry)
    process_ids(entry)
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
end
