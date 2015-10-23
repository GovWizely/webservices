class CountryFactSheet
  include Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer: {
          custom_analyzer:        {
            tokenizer: 'standard',
            filter:    %w(standard asciifolding lowercase snowball),
          },
          title_keyword_analyzer: {
            tokenizer: 'keyword',
            filter:    %w(asciifolding lowercase),
          },
        },
      },
    },
  }.freeze

  self.mappings = {
    name.typeize => {
      _timestamp: {
        enabled: true,
        store:   true,
      },
      dynamic:    'false',
      properties: {
        title:          { type: 'string', analyzer: 'title_keyword_analyzer' },
        content_html:   { type: 'string', analyzer: 'standard' },
        country:        { type: 'string', analyzer: 'title_keyword_analyzer' },
        source:         { type: 'string', analyzer: 'title_keyword_analyzer' },
        topic:          { type: 'string', analyzer: 'title_keyword_analyzer' },
        published_date: { type: 'date', format: 'YYYY-MM-dd' },
      },
    },
  }.merge(metadata_mappings).freeze

  self.source = {
    full_name: 'U.S. Department of State',
    code:      'STATE',
  }
end
