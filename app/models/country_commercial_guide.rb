class CountryCommercialGuide
  include Indexable

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
      _timestamp: {
        enabled: true,
        store:   true,
      },
      dynamic:    'false',
      properties: {
        pdf_title:     { type: 'string', analyzer: 'custom_analyzer' },
        pdf_chapter:   { type: 'string', analyzer: 'custom_analyzer' },
        pdf_section:   { type: 'string', analyzer: 'custom_analyzer' },
        pdf_url:       { type: 'string' },

        section_title: { type: 'string', analyzer: 'custom_analyzer' },
        country:       { type: 'string', analyzer: 'title_keyword_analyzer' },
        industry:      { type: 'string', analyzer: 'title_keyword_analyzer' },
        topic:         { type: 'string', analyzer: 'title_keyword_analyzer' },
        content:       { type: 'string', analyzer: 'custom_analyzer' },
        section_url:   { type: 'string' },
      },
    },
  }.freeze

  self.source = {
    full_name: 'Country Commercial Guide',
    code:      'CCG',
  }
end
