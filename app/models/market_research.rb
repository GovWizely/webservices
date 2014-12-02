class MarketResearch
  extend Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer:
                  { custom_analyzer:        {
                    tokenizer: 'standard',
                    filter:    %w(standard asciifolding lowercase snowball) },
                    title_keyword_analyzer: {
                      tokenizer: 'keyword',
                      filter:    %w(asciifolding lowercase) },
            },
      },
    },
  }.freeze

  self.mappings = {
    name.typeize => {
      properties: {
        countries:   { type: 'string', analyzer: 'keyword' },
        description: { type: 'string', analyzer: 'custom_analyzer' },
        industries:  { type: 'string', analyzer: 'custom_analyzer' },
        industries:  {
          type:       'nested',
          properties: {
            original: { type: 'string', analyzer: 'custom_analyzer' },
            mapped:   { type: 'string', analyzer: 'custom_analyzer' },
          },
        },
        title:       {
          type: 'string', analyzer: 'custom_analyzer',
          fields: {
            keyword: { type: 'string', analyzer: 'title_keyword_analyzer' },
          }
        },
      },
    },
  }.freeze
end
