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
      dynamic:    'false',
      properties: {
        _updated_at:    { type: 'date', format: 'strictDateOptionalTime' },
        name:           { type: 'string', analyzer: 'standard' },
        taxonomies:     { type: 'string', analyzer: 'lowercase_keyword_analyzer' },
        path:           { type: 'string', index: 'not_analyzed'  },
        broader_terms:  { type: 'string', analyzer: 'standard' },
        narrower_terms: { type: 'string', analyzer: 'standard' },
      },
    },
  }.merge(metadata_mappings).freeze

  self.source = {
    full_name: 'ITA',
    code:      'ITAT',
  }
end
