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
            id:                       { type: 'string', index: :not_analyzed, include_in_all: false },
            country:                  { type: 'string', analyzer: 'keyword' },
            description:              { type: 'string', analyzer: 'custom_analyzer' },
            contract_number:          { type: 'string', index: 'not_analyzed' },
            reference_number:         { type: 'string', index: 'not_analyzed' },
            industry:                 { type: 'string', analyzer: 'custom_analyzer' },
            title:                    {
              type:   'multi_field',
              fields: {
                title:   { type: 'string', analyzer: 'custom_analyzer' },
                keyword: { type: 'string', analyzer: 'lead_keyword_analyzer' },
                raw:     { type: 'string', index: 'not_analyzed' },
              },
            },
            publish_date:             { type: 'date' },
            publish_date_amended:     { type: 'date' },
            end_date:                 { type: 'date' },
            end_date:                 { type: 'date' },
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
