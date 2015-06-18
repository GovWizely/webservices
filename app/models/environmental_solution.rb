class EnvironmentalSolution
  include Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer:
                  { english_analyzer:    {
                    tokenizer: 'standard',
                    filter:    %w(standard asciifolding lowercase snowball) },
                    french_analyzer:     {
                      tokenizer: 'standard',
                      filter:    %w(standard asciifolding lowercase french) },
                    chinese_analyzer:    {
                      tokenizer: 'standard',
                      filter:    %w(standard  lowercase) },
                    portuguese_analyzer: {
                      tokenizer: 'standard',
                      filter:    %w(standard asciifolding lowercase portuguese) },
                    spanish_analyzer:    {
                      tokenizer: 'standard',
                      filter:    %w(standard asciifolding lowercase spanish) },

            },
        filter:   {
          french:     { type:     'snowball',
                        language: 'French' },
          portuguese: { type:     'snowball',
                        language: 'Portuguese' },
          spanish:    { type:     'snowball',
                        language: 'Spanish' },
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
        name_chinese:      { type: 'string', analyzer: 'chinese_analyzer' },
        name_english:      { type: 'string', analyzer: 'english_analyzer' },
        name_french:       { type: 'string', analyzer: 'french_analyzer' },
        name_portuguese:   { type: 'string', analyzer: 'portuguese_analyzer' },
        name_spanish:      { type: 'string', analyzer: 'spanish_analyzer' },
        source_created_at: { type: 'date', format: 'YYYY-MM-dd' },
        source_updated_at: { type: 'date', format: 'YYYY-MM-dd' },
        source_id:         { type: 'string' },
      },
    },
  }.freeze
end
