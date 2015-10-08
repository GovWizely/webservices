require 'open-uri'
require 'zip'

class ItaTaxonomyData
  include Importable
  include VersionableResource
  #  This is the staging URL, need to make sure this gets changed to prod
  PROTEGE_URL = 'http://52.4.82.207:8080/webprotege/download?ontology=0aa09276-58a6-4350-a0bb-60eb2ab4be00'

  def initialize(resource = PROTEGE_URL)
    @resource = resource
    @terms = []
    @industry_terms = []
    @world_region_terms = []
    @country_terms = []
    @trade_region_terms = []
    @topic_terms = []
    @industries_root = {}
    @world_regions_root = {}
    @countries_root = {}
    @trade_regions_root = {}
    @topics_root = {}
  end

  def import
    xml = extract_xml_from_zip
    parse_terms_from_xml(xml)

    find_parent_names
    extract_actual_taxonomy_terms

    ItaTaxonomy.index build_json_entries
  end

  private

  def build_json_entries
    entries = @industry_terms + @world_region_terms + @country_terms + @trade_region_terms + @topic_terms
    entries.each do |entry|
      entry.delete(:parent_ids)
      entry[:id] = Utils.generate_id(entry, %i(id name taxonomy))
    end
    entries
  end

  def extract_actual_taxonomy_terms
    @terms.each do |term|
      case get_taxonomy_type_of_term(term)
      when @industries_root
        term[:taxonomy] = @industries_root[:name]
        @industry_terms.push(term)
      when @world_regions_root
        term[:taxonomy] = @world_regions_root[:name]
        @world_region_terms.push(term)
      when @countries_root
        term[:taxonomy] = @countries_root[:name]
        @country_terms.push(term)
      when @trade_regions_root
        term[:taxonomy] = @trade_regions_root[:name]
        @trade_region_terms.push(term)
      when @topics_root
        term[:taxonomy] = @topics_root[:name]
        @topic_terms.push(term)
      end
    end
  end

  def get_taxonomy_type_of_term(term)
    root_terms = [@industries_root, @world_regions_root, @countries_root, @trade_regions_root, @topics_root]
    if root_terms.map { |root| root[:id] }.include? term[:parent_ids][0]
      return root_terms.find { |root| root[:id] == term[:parent_ids][0] }
    elsif ['skos:Concept', 'Concept Scheme', 'Collection'].include?(term[:name]) || term[:parent_ids] == []
      return nil
    else
      @terms.each do |t|
        return get_taxonomy_type_of_term(t) if term[:parent_ids].include?(t[:id])
      end
    end
  end

  def extract_xml_from_zip
    open('temp.zip', 'wb') { |file| file << open(@resource).read }

    content = ''
    Zip::File.open('temp.zip') do |zip_file|
      zip_file.each do |entry|
        content = entry.get_input_stream.read if entry.name.end_with?('.owl')
      end
    end

    File.delete('temp.zip')
    Nokogiri::XML(content)
  end

  def parse_terms_from_xml(xml)
    classes = xml.xpath('//owl:Class')
    classes.each do |owl_class|
      parents = owl_class.xpath('./rdfs:subClassOf').select { |parent| !parent.attr('rdf:resource').nil? }
      parent_ids = parents.map { |parent| parent.attr('rdf:resource') }
      term_hash = { name:       owl_class.xpath('./rdfs:label').text,
                    id:         owl_class.attr('rdf:about'),
                    parent_ids: parent_ids }
      case owl_class.xpath('./rdfs:label').text
      when 'Industries'
        @industries_root = term_hash
      when 'World Regions'
        @world_regions_root = term_hash
      when 'ISO 3166 Countries'
        term_hash[:name] = 'Countries'
        @countries_root = term_hash
      when 'Trade Regions'
        @trade_regions_root = term_hash
      when 'Topics'
        @topics_root = term_hash
      end
      @terms << term_hash
    end
  end

  def find_parent_names
    @terms.each do |term|
      parents = @terms.select { |t| term[:parent_ids].include? t[:id] }
      term[:parent_names] = parents.map { |t| t[:name] }
    end
  end
end
