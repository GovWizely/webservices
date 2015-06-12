class Eccn
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
        description: { type: 'string', analyzer: 'custom_analyzer' },
        eccn0:       { type: 'string', analyzer: 'title_keyword_analyzer' },
        eccn1:       { type: 'string', analyzer: 'title_keyword_analyzer' },
        eccn2:       { type: 'string', analyzer: 'title_keyword_analyzer' },
        eccn3:       { type: 'string', analyzer: 'title_keyword_analyzer' },
        eccn4:       { type: 'string', analyzer: 'title_keyword_analyzer' },
        url0:        { type: 'string', analyzer: 'custom_analyzer' },
        url1:        { type: 'string', analyzer: 'custom_analyzer' },
        url2:        { type: 'string', analyzer: 'custom_analyzer' },
      },
    },
  }.freeze
end
