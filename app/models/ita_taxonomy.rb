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
        char_filter: {
          strip_commas: {
            type:     'mapping',
            mappings: [
              ',=>',
            ],
          },
        },
        analyzer:    {
          lowercase_keyword_analyzer: {
            tokenizer: 'keyword',
            filter:    %w(asciifolding lowercase), },
          keyword_strip_commas:       {
            tokenizer:   'keyword',
            char_filter: ['strip_commas'], },
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
            keyword:   { type: 'string', analyzer: 'keyword_strip_commas' },
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
