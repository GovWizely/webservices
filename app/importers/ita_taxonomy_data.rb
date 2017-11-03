require 'open-uri'
require 'zip'

class ItaTaxonomyData
  include Importable
  include VersionableResource

  LOOKUP_MAPPINGS = {
        "Cape Verde" => "Verde",
        "Pitcairn Islands" => "Pitcairn",
        "South Korea" => "Korea (Republic of)",
        "Guinea Bissau" => "Guinea-Bissau",
        "North Korea" => "Korea (Democratic People's Republic of)",
        "British Virgin Islands" => "Virgin Islands (British)",
        "United States" => "United States of America"
      }
  PARTIAL_MATCH_URL = "https://restcountries.eu/rest/v2/name/%s"
  FULL_MATCH_URL = PARTIAL_MATCH_URL + "?fullText=true"

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
    process_country_fields(entry) if is_country_entry?(entry)
  end

  def process_country_fields(entry)
    name = LOOKUP_MAPPINGS.key?(entry[:label]) ? LOOKUP_MAPPINGS[entry[:label]] : entry[:label]
    response = country_lookup(FULL_MATCH_URL % URI.escape(name))
    response = country_lookup(PARTIAL_MATCH_URL % URI.escape(name)) if !response
    add_country_fields(entry, response) if response
  end

  def add_country_fields(entry, response)
    entry[:annotations][:iso_alpha_2] = response.first['alpha2Code']
    entry[:annotations][:iso_alpha_3] = response.first['alpha3Code']
    entry[:annotations][:iso_numeric] = response.first['numericCode'].to_i
    entry[:annotations][:iso_short_name] = response.first['name']
  end

  def is_country_entry?(entry)
    entry[:type].include?('Countries') && !entry[:sub_class_of].include?({id: "RC4HD9CwKjvgX8dSybAp3Sk", label: 'United States'})
  end

  def country_lookup(url)
    response = nil
    begin
        response = JSON.parse(open(url).read)
    rescue OpenURI::HTTPError => e 
    end
    return response
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
