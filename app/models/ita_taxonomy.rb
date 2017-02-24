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
          label_analyzer:             {
            tokenizer: 'lowercase',
            filter:    'asciifolding',
          },
        },
      },
    },
  }.freeze

  self.mappings = {
    name.typeize => {
      dynamic:    'true',
      properties: {
        _updated_at:   { type: 'date', format: 'strictDateOptionalTime' },
        label:         {
          type:   'text',
          fields: {
            tokenized: { type: 'text', analyzer: 'label_analyzer' },
            keyword:   { type: 'text', analyzer: 'keyword_strip_commas' },
          },
        },
        label_suggest: {
          type:                         'completion',
          analyzer:                     'label_analyzer',
          preserve_separators:          true,
          preserve_position_increments: true,
          max_input_length:             50,
        },
        type:          { type: 'text', analyzer: 'lowercase_keyword_analyzer' },
      },
    },
  }.merge(metadata_mappings,).freeze

  self.source = {
    full_name: 'ITA',
    code:      'ITAT',
  }
end
