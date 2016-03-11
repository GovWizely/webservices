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
      dynamic:    'true',
      properties: {
        _updated_at:    { type: 'date', format: 'strictDateOptionalTime' },
        label:                 {
          type:   'string',
          fields: {
            tokenized: { type: 'string', analyzer: 'standard' },
            keyword:   { type: 'string', analyzer: 'lowercase_keyword_analyzer' },
          },
        },
        subject:               { type: 'string', index: 'not_analyzed' }
      },
    },
  }.merge(metadata_mappings).freeze

  self.source = {
    full_name: 'ITA',
    code:      'ITAT',
  }
end
