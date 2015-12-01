module TradeLead
  module Mappable
    def self.included(klass)
      klass.analyze_by :snowball_asciifolding_nostop, :keyword_asciifolding_lowercase
      klass.settings.freeze

      klass.mappings = {
        klass.name.typeize => {
          _timestamp: {
            enabled: true,
            store:   true,
          },
          properties: {
            country:                  { type: 'string', analyzer: 'keyword' },
            description:              { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            contract_number:          { type: 'string', index: 'not_analyzed' },
            reference_number:         { type: 'string', index: 'not_analyzed' },
            industry:                 { type:   'string',
                                        fields: {
                                          tokenized: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
                                          keyword:   { type: 'string', analyzer: 'keyword' },
                                        },
                                      },
            ita_industries:           {
              type:   'string',
              fields: {
                tokenized: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
                keyword:   { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
              },
            },
            title:                    {
              type: 'string', analyzer: 'snowball_asciifolding_nostop',
              fields: {
                keyword: { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
                raw:     { type: 'string', index: 'not_analyzed' },
              }
            },
            publish_date:             { type: 'date', format: 'YYYY-MM-dd' },
            publish_date_amended:     { type: 'date', format: 'YYYY-MM-dd' },
            end_date:                 { type: 'date', format: 'YYYY-MM-dd' },
            specific_location:        { type: 'string', analyzer: 'standard' },
            tags:                     { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            implementing_entity:      { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            procurement_organization: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            source_lead:              { type: 'string', analyzer: 'keyword' },
            source:                   { type: 'string', analyzer: 'keyword' },
            categories:               { type: 'string', analyzer: 'keyword' },
          },
        },
      }.merge(klass.metadata_mappings).freeze

      klass.class_eval do
        class << self
          attr_accessor :source
        end
      end
    end
  end
end
