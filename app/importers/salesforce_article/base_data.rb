module SalesforceArticle
  class BaseData
    attr_accessor :client

    FIELD_MAPPING = {
      'Id'                 => :id,
      'Atom__c'            => :atom,
      'Business_Unit__c'   => :business_unit,
      'Chapter__c'         => :chapter,
      'FirstPublishedDate' => :first_published_date,
      'LastPublishedDate'  => :last_published_date,
      'Lead_DMO__c'        => :lead_dmo,
      'Public_URL__c'      => :public_url,
      'References__c'      => :references,
      'Section__c'         => :section,
      'Summary'            => :summary,
      'Title'              => :title,
      'UrlName'            => :url_name,
    }

    DATA_CATEGORY_GROUP_NAMES = %w(Geographies Industries Trade_Topics).freeze

    def query_string
      fail 'Must be overridden by subclass'
    end

    def initialize(client = nil)
      @client = client || Restforce.new(Rails.configuration.restforce)

      @taxonomy_parser = TaxonomyParser.new(Rails.configuration.frozen_protege_source)
      @taxonomy_parser.concepts = YAML.load_file(Rails.configuration.frozen_taxonomy_concepts)
    end

    def loaded_resource
      @loaded_resource ||= @client.query(query_string)
    end

    def import
      model_class.index indexable_entries
    end

    def indexable_entries
      loaded_resource.map do |article|
        entry = remap_keys(FIELD_MAPPING, article)
        entry = sanitize_entry(entry)

        process_date_fields(entry)
        extract_taxonomy_fields(entry, article)

        entry[:source] = model_class.source[:code]
        entry
      end
    end

    def extract_taxonomy_fields(entry, article)
      taxonomy_terms = extract_taxonomies article['DataCategorySelections']

      entry[:industries] = get_concept_labels_by_concept_group('Industries', taxonomy_terms)
      entry[:topics] = get_concept_labels_by_concept_group('Topics', taxonomy_terms)

      process_geo_fields(entry, taxonomy_terms)
    end

    def process_geo_fields(entry, taxonomy_terms)
      entry[:countries] = get_concept_labels_by_concept_group('Countries', taxonomy_terms)
      entry[:countries] = entry[:countries].map { |country| lookup_country(country) }.compact

      entry.merge! add_geo_fields(entry[:countries])

      entry[:trade_regions].concat(get_concept_labels_by_concept_group('Trade Regions', taxonomy_terms)).uniq!
      entry[:world_regions].concat(get_concept_labels_by_concept_group('World Regions', taxonomy_terms)).uniq!
    end

    def process_date_fields(entry)
      entry[:first_published_date] = parse_date(entry[:first_published_date]) if entry[:first_published_date]
      entry[:last_published_date] = parse_date(entry[:last_published_date]) if entry[:last_published_date]
      entry[:article_expiration_date] = parse_date(entry[:article_expiration_date]) if entry[:article_expiration_date]
    end

    def get_concept_labels_by_concept_group(concept_group, terms)
      @taxonomy_parser.get_concepts_by_concept_group(concept_group, terms).map { |term| term[:label] }
    end

    def extract_taxonomies(data_categories)
      filtered_data_categories = filter_data_categories data_categories

      filtered_data_categories.each_with_object([]) do |dc, taxonomies|
        label = dc.DataCategoryName.gsub(/_/, ' ')
        concept = @taxonomy_parser.get_concept_by_label(label)
        taxonomies << concept if concept
      end
    end

    def filter_data_categories(data_categories)
      data_categories ||= []
      data_categories.select do |dc|
        DATA_CATEGORY_GROUP_NAMES.include? dc.DataCategoryGroupName
      end
    end
  end
end
