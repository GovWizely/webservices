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
        klass.to_s.typeize => {
          _ttl:       { enabled: true },
          properties: {
            cost:        { type: 'float' },
            country:     { type: 'string', analyzer: 'keyword' },
            description: { type: 'string', analyzer: 'custom_analyzer' },
            end_date:    { type: 'date', format: 'YYYY-MM-dd' },
            event_name:  { type: 'string', analyzer: 'custom_analyzer' },
            industries:  { type: 'string', analyzer: 'custom_analyzer' },
            start_date:  { type: 'date', format: 'YYYY-MM-dd' },
            id:          { type: 'string', index: :not_analyzed, include_in_all: false },
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
