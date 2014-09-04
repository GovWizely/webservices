class UkTradeLead
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
      uk_trade_lead: {
          properties: {
            country:                  { type: 'string', analyzer: 'keyword' },
            publish_date:             { type: 'date', format: 'YYYY-MM-dd' },
            procurement_organization: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            description:              { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            title:                    { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            id:                       { type: 'string', index: :not_analyzed, include_in_all: false }
          }
      }
  }.freeze
end
