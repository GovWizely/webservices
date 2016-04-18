module SalesforceArticle
  class BaseData
    attr_accessor :client

    FIELD_MAPPING = {
      'Id'                 => :id,
      'FirstPublishedDate' => :first_published_date,
      'LastPublishedDate'  => :last_published_date,
      'References__c'      => :references,
      'Summary'            => :summary,
      'Title'              => :title,
      'UrlName'            => :url_name,
    }

    PUBLIC_URL_PREFIX = 'https://success.export.gov/article2?id='

    DATA_CATEGORY_GROUP_NAMES = %w(Geographies Industries Trade_Topics).freeze

    def query_string
      raise 'Must be overridden by subclass'
    end

    def initialize(client = nil)
      @client = client || Restforce.new(Rails.configuration.restforce)
    end

    def loaded_resource
      @loaded_resource ||= @client.query(query_string)
    end

    def import
      model_class.index indexable_entries
    end

    def indexable_entries
      loaded_resource.map do |article|
        entry = remap_keys(self.class::FIELD_MAPPING, article)
        entry = sanitize_entry(entry)

        process_url(entry)
        process_date_fields(entry)
        extract_taxonomy_fields(entry, article)

        entry[:source] = model_class.source[:code]
        entry
      end
    end

    def process_url(entry)
      entry[:public_url] = entry[:url_name].present? ? (PUBLIC_URL_PREFIX + entry[:url_name]) : nil
    end

    def extract_taxonomy_fields(entry, article)
      taxonomy_terms = extract_taxonomies article['DataCategorySelections']
      entry[:industries] = get_concept_labels_by_concept_group('Industries', taxonomy_terms)
      entry[:topics] = get_concept_labels_by_concept_group('Topics', taxonomy_terms)

      process_geo_fields(entry, taxonomy_terms)
    end

    def process_geo_fields(entry, taxonomy_terms)
      entry[:countries] = get_concept_labels_by_concept_group('Countries', taxonomy_terms)
      entry.merge! add_related_fields(entry[:countries])

      entry[:countries] = entry[:countries].map { |country| lookup_country(country) }.compact

      entry[:trade_regions].concat(get_concept_labels_by_concept_group('Trade Regions', taxonomy_terms)).uniq!
      entry[:world_regions].concat(get_concept_labels_by_concept_group('World Regions', taxonomy_terms)).uniq!
    end

    def process_date_fields(entry)
      entry[:first_published_date] = parse_date(entry[:first_published_date]) if entry[:first_published_date]
      entry[:last_published_date] = parse_date(entry[:last_published_date]) if entry[:last_published_date]
      entry[:article_expiration_date] = parse_date(entry[:article_expiration_date]) if entry[:article_expiration_date]
    end

    def get_concept_labels_by_concept_group(concept_group, terms)
      terms.select { |term| term[:type].include?(concept_group) }.map { |term| term[:label] }
    end

    def extract_taxonomies(data_categories)
      filtered_data_categories = filter_data_categories data_categories

      filtered_data_categories.each_with_object([]) do |dc, taxonomies|
        label = dc.DataCategoryName.tr('_', ' ')

        results = ItaTaxonomy.search_related_terms(labels: label, size: 1)
        concept = results.empty? ? nil : results[0]

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
