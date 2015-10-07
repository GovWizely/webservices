class CountryFactSheet
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
    name.typeize => {
      _timestamp: {
        enabled: true,
        store:   true,
      },
      dynamic:    'false',
      properties: {
        title:         { type: 'string', analyzer: 'title_keyword_analyzer' },
        site_url:      { type: 'string', analyzer: 'not_analyzed' },
        content_url:   { type: 'string', analyzer: 'not_analyzed' },
        full_url:      { type: 'string', analyzer: 'not_analyzed' },
        mobile_url:    { type: 'string', analyzer: 'not_analyzed' },
        bureau:        { type: 'string', analyzer: 'title_keyword_analyzer' },
        official_name: { type: 'string', analyzer: 'title_keyword_analyzer' },
        content_html:  { type: 'string', analyzer: 'standard' },
        full_html:     { type: 'string', analyzer: 'standard' },
      },
    },
  }.freeze

  self.source = {
    full_name: 'CountryFactSheet',
    code:      'CountryFactSheet'
  }
end
