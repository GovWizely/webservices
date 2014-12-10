class CountryCommercialGuide
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
    contry_commercial_guide: {
      properties: {
        content:   { type: 'string' },
        title:       {
          type:   'multi_field',
          fields: {
            title:   { type: 'string', analyzer: 'custom_analyzer' },
            keyword: { type: 'string', analyzer: 'title_keyword_analyzer' },
          },
        },
        id:          { type: 'string', index: :not_analyzed, include_in_all: false },
      },
    },
  }.freeze
end
