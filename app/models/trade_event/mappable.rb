module TradeEvent
  module Mappable
    def self.included(klass)
      klass.analyze_by :snowball_asciifolding_nostop

      klass.settings.freeze

      klass.mappings = {
        klass.name.typeize => {
          properties: {
            _updated_at:        { type: 'date', format: 'strictDateOptionalTime' },
            cost:               { type: 'float' },
            country:            { type: 'string', analyzer: 'keyword' },
            state:              { type: 'string', analyzer: 'keyword' },
            start_date:         { type: 'date', format: 'YYYY-MM-dd' },
            end_date:           { type: 'date', format: 'YYYY-MM-dd' },

            description:        { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            event_name:         { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            registration_title: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            industries:         { type:   'string',
                                  fields: {
                                    tokenized: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
                                    keyword:   { type: 'string', analyzer: 'keyword' },
                                  },
                                },
            ita_industries:           {
              type:   'string',
              fields: {
                tokenized: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
                keyword:   { type: 'string', analyzer: 'keyword' },
              },
            },

            venues:             { properties: { venue:        { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
                                                address:      { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
                                                city:         { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
                                                state:        { type: 'string', analyzer: 'keyword' },
                                                country:      { type: 'string', analyzer: 'keyword' },
                                                country_name: { type: 'string', analyzer: 'snowball_asciifolding_nostop' }, }, },

            source:             { type: 'string', analyzer: 'keyword' },
            trade_regions:      { type: 'string', analyzer: 'keyword' },
            world_regions:      { type: 'string', analyzer: 'keyword' },
          },
        },
      }.merge(klass.metadata_mappings,).freeze

      klass.class_eval do
        class << self
          attr_accessor :source
        end
      end
    end
  end
end
