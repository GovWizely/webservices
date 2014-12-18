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
    country_commercial_guide: {
      properties: {
        title: { type: 'string', analyzer: 'custom_analyzer' },
        section: { type: 'string', analyzer: 'custom_analyzer' },
        content: { type: 'string', analyzer: 'custom_analyzer' },
        md_url: { type: 'string' },
        pdf_url: { type: 'string' },
        id: { type: 'string', index: :not_analyzed, include_in_all: false },
      },
    },
  }.freeze
end
