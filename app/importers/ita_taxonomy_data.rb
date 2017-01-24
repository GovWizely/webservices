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
    processed_entries = @taxonomy_parser.terms.map do |term|
      entry = term.deep_dup
      process_entry(entry)
      entry
    end
    assign_suggest processed_entries
    processed_entries
  end

  def process_entry(entry)
    entry[:type] = @taxonomy_parser.get_high_level_type(entry[:label])
    process_ids(entry)
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

  def get_geo_terms(country, type)
    @taxonomy_parser.get_all_geo_terms_for_country(country).select do |term|
      term[:object_properties][:member_of].map { |t| t[:label] }.include?(type)
    end.map { |term| term[:label] }
  end

  def add_geo_fields(countries)
    trade_regions = []
    world_regions = []

    countries.compact.each do |country|
      trade_regions.concat get_geo_terms(country, 'Trade Regions')
      world_regions.concat get_geo_terms(country, 'World Regions')
    end

    {
      trade_regions: trade_regions.uniq,
      world_regions: world_regions.uniq,
    }
  end

  def assign_suggest(entries)
    entries.sort! { |a, b| I18n.transliterate(a[:label]) <=> I18n.transliterate(b[:label]) }
    weight = entries.count
    entries.each do |entry|
      entry[:label_suggest] = {
        input:  entry[:label],
        weight: weight,
      }
      weight -= 1
    end
  end
end
