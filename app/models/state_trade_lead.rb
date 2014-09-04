class StateTradeLead
  extend Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer: {
          snowball_asciifolding_nostop: {
            type: 'custom',
            tokenizer: 'standard',
            filter: %w(standard asciifolding lowercase snowball)
          }
        }
      }
    }
  }.freeze

  self.mappings = {
    state_trade_lead: {
      properties: {
        country:              { type: 'string', analyzer: 'keyword' },
        specific_location:    { type: 'string', analyzer: 'standard' },
        industry:             { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

        description:          { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        title:                { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        tags:                 { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
        implementing_entity:  { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

        publish_date:         { type: 'date',   format: 'YYYY-MM-dd' },
        end_date:             { type: 'date',   format: 'YYYY-MM-dd' },
        id:                   { type: 'string', index: :not_analyzed, include_in_all: false }
      }
    }
  }.freeze
end
