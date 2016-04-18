class ItaTaxonomy
  include Indexable

  def self.search_related_terms(params)
    results = search_for(params.reverse_merge(size: '100'))
    results[:hits].map do |result|
      { label:         result[:_source][:label],
        type:          result[:_source][:type],
        related_terms: result[:_source][:related_terms], }
    end
  end

  self.settings = {
    index: {
      analysis: {
        analyzer:
                  { lowercase_keyword_analyzer: {
                    tokenizer: 'keyword',
                    filter:    %w(asciifolding lowercase), },
            },
      },
    },
  }.freeze

  self.mappings = {
    name.typeize => {
      dynamic:    'true',
      properties: {
        _updated_at: { type: 'date', format: 'strictDateOptionalTime' },
        label:       {
          type:   'string',
          fields: {
            tokenized: { type: 'string', analyzer: 'standard' },
            keyword:   { type: 'string', analyzer: 'lowercase_keyword_analyzer' },
          },
        },
        type:        { type: 'string', analyzer: 'lowercase_keyword_analyzer' },
      },
    },
  }.merge(metadata_mappings,).freeze

  self.source = {
    full_name: 'ITA',
    code:      'ITAT',
  }
end
