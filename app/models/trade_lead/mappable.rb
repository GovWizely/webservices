module TradeLead
  module Mappable
    def self.included(klass)
      klass.settings = {
        index: {
          analysis: {
            analyzer: {
              custom_analyzer:       {
                tokenizer: 'standard',
                filter:    %w(standard asciifolding lowercase snowball),
              },
              lead_keyword_analyzer: {
                tokenizer: 'keyword',
                filter:    %w(asciifolding lowercase),
              },
            },
          },
        },
      }.freeze

      klass.mappings = {
        klass.name.typeize => {
          _timestamp: {
            enabled: true,
            store:   true,
          },
          properties: {
            country:                  { type: 'string', analyzer: 'keyword' },
            description:              { type: 'string', analyzer: 'custom_analyzer' },
            contract_number:          { type: 'string', index: 'not_analyzed' },
            reference_number:         { type: 'string', index: 'not_analyzed' },
            industry:                 { type:   'string',
                                        fields: {
                                          tokenized: { type: 'string', analyzer: 'custom_analyzer' },
                                          keyword:   { type: 'string', analyzer: 'keyword' },
                                        },
                                      },
            title:                    {
              type: 'string', analyzer: 'custom_analyzer',
              fields: {
                keyword: { type: 'string', analyzer: 'lead_keyword_analyzer' },
                raw:     { type: 'string', index: 'not_analyzed' },
              }
            },
            publish_date:             { type: 'date', format: 'YYYY-MM-dd' },
            publish_date_amended:     { type: 'date', format: 'YYYY-MM-dd' },
            end_date:                 { type: 'date', format: 'YYYY-MM-dd' },
            specific_location:        { type: 'string', analyzer: 'standard' },
            tags:                     { type: 'string', analyzer: 'custom_analyzer' },
            implementing_entity:      { type: 'string', analyzer: 'custom_analyzer' },
            procurement_organization: { type: 'string', analyzer: 'custom_analyzer' },
            source_lead:              { type: 'string', analyzer: 'keyword' },
            source:                   { type: 'string', analyzer: 'keyword' },
          },
        },
      }.freeze

      klass.class_eval do
        class << self
          attr_accessor :source
        end
      end
    end
  end
end
