class ItaTaxonomy
  include Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer:
                  {   lowercase_keyword_analyzer: {
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
        name:         { type: 'string', analyzer: 'standard' },
        taxonomy:     { type: 'string', analyzer: 'lowercase_keyword_analyzer' },
        parent_names: { type: 'string', analyzer: 'standard' },
      },
    },
  }.freeze
end
