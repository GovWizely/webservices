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
        expiration_date: { type: 'date', format: 'YYYY-MM-dd' },
        countries:   { type: 'string', analyzer: 'keyword' },
        description: { type: 'string', analyzer: 'custom_analyzer' },
        industries:  {
          properties: {
            original: {
              type:   'string',
              fields: {
                tokenized: { type: 'string', analyzer: 'custom_analyzer' },
                keyword:   { type: 'string', analyzer: 'title_keyword_analyzer' },
              },
            },
            mapped:   {
              type:   'string',
              fields: {
                tokenized: { type: 'string', analyzer: 'custom_analyzer' },
                keyword:   { type: 'string', analyzer: 'title_keyword_analyzer' },
              },
            },
          },
        },
        title:           {
          type: 'string', analyzer: 'custom_analyzer',
          fields: {
            keyword: { type: 'string', analyzer: 'title_keyword_analyzer' },
          }
        },
      },
    },
  }.freeze
end
