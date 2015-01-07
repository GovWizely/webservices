module TradeEvent
  module Mappable
    def self.included(klass)
      klass.settings = {
        index: {
          analysis: {
            analyzer: { custom_analyzer: { type:      'custom',
                                           tokenizer: 'standard',
                                           filter:    %w(standard asciifolding lowercase snowball) },
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
            cost:               { type: 'float' },
            country:            { type: 'string', analyzer: 'keyword' },
            state:              { type: 'string', analyzer: 'keyword' },
            start_date:         { type: 'date', format: 'YYYY-MM-dd' },
            end_date:           { type: 'date', format: 'YYYY-MM-dd' },

            description:        { type: 'string', analyzer: 'custom_analyzer' },
            event_name:         { type: 'string', analyzer: 'custom_analyzer' },
            registration_title: { type: 'string', analyzer: 'custom_analyzer' },
            industries:         { type: 'string', analyzer: 'custom_analyzer' },

            venues:             { properties: { venue:   { type: 'string', analyzer: 'custom_analyzer' },
                                                address: { type: 'string', analyzer: 'custom_analyzer' },
                                                city:    { type: 'string', analyzer: 'custom_analyzer' },
                                                state:   { type: 'string', analyzer: 'keyword' },
                                                country: { type: 'string', analyzer: 'keyword' } } },

            source:             { type: 'string', analyzer: 'keyword' },
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
