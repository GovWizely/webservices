module ScreeningList
  module Mappable
    def self.included(klass)
      klass.settings = {
        index: {
          analysis: {
            analyzer: {
              snowball_asciifolding_nostop: {
                tokenizer: 'standard',
                filter:    %w(standard asciifolding lowercase snowball),
              },
              keyword_lowercase:            {
                tokenizer: 'keyword',
                filter:    %w(lowercase asciifolding),
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
            id:                      { type: 'integer', index: :not_analyzed, include_in_all: false },

            name:                    { type:   'multi_field',
                                       fields: {
                                         name: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
                                         sort: { type: 'string', analyzer: 'keyword_lowercase' } } },

            alt_names:               { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            remarks:                 { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            title:                   { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            type:                    { type: 'string', analyzer: 'keyword_lowercase' },
            source:                  { properties: { full_name: { type: 'string', index: 'no' },
                                                     code:      { type: 'string', analyzer: 'keyword' } } },
            federal_register_notice: { type: 'string', analyzer: 'keyword' },

            addresses:               { properties: { country:         { type: 'string', analyzer: 'keyword' } } },
            ids:                     { properties: { country:         { type: 'string', analyzer: 'keyword' },
                                                     issue_date:      { type: 'date',   format: 'YYYY-MM-dd' },
                                                     expiration_date: { type: 'date',   format: 'YYYY-MM-dd' } } },

            nationalities:           { type: 'string', analyzer: 'keyword' },
            citizenships:            { type: 'string', analyzer: 'keyword' },
            dates_of_birth:          { type: 'string', analyzer: 'keyword' },
            start_date:              { type: 'date',   format: 'YYYY-MM-dd' },
            end_date:                { type: 'date',   format: 'YYYY-MM-dd' },

            entity_number:           { type: 'integer' },
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
