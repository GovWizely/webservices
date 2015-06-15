class Est
  include Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer:
            { custom_analyzer:        {
              tokenizer: 'standard',
              filter:    %w(standard asciifolding lowercase snowball) },
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
        name_chinese:      { type: 'string', analyzer: 'custom_analyzer' },
        name_english:      { type: 'string', analyzer: 'custom_analyzer' },
        name_french:       { type: 'string', analyzer: 'custom_analyzer' },
        name_portuguese:   { type: 'string', analyzer: 'custom_analyzer' },
        name_spanish:      { type: 'string', analyzer: 'custom_analyzer' },
        source_created_at: { type: 'date', format: 'YYYY-MM-dd' },
        source_updated_at: { type: 'date', format: 'YYYY-MM-dd' },
        source_id:         { type: 'string' },
      },
    },
  }.freeze
end
