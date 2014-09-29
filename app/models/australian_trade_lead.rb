class AustralianTradeLead
  extend Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer:
                  { custom_analyzer:              {
                    tokenizer: 'standard',
                    filter:    %w(standard asciifolding lowercase snowball) },
                    description_keyword_analyzer: {
                      tokenizer: 'keyword',
                      filter:    %w(asciifolding lowercase) },
            },
      },
    },
  }.freeze

  self.mappings = {
    australian_trade_lead: {
      properties: {
        countries:   { type: 'string', analyzer: 'keyword' },
        description: { type: 'string', analyzer: 'custom_analyzer' },
        id:          { type: 'string', index: :not_analyzed, include_in_all: false },
      },
    },
  }.freeze
end
