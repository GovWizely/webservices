module Envirotech
  module Mappable
    def self.included(klass)
      klass.settings = {
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

      klass.mappings = {
        klass.name.typeize => {
          properties: {
            _updated_at:          { type: 'date', format: 'strictDateOptionalTime' },
            name_chinese:        { type: 'string', analyzer: 'chinese_analyzer' },
            name_english:        {
              type:     'string',
              analyzer: 'english_analyzer',
              fields:   {
                sort: { type: 'string', analyzer: 'keyword' },
              },
            },
            name_french:         { type: 'string', analyzer: 'french_analyzer' },
            name_portuguese:     { type: 'string', analyzer: 'portuguese_analyzer' },
            name_spanish:        { type: 'string', analyzer: 'spanish_analyzer' },

            abstract_chinese:    { type: 'string', analyzer: 'chinese_analyzer' },
            abstract_english:    { type: 'string', analyzer: 'english_analyzer' },
            abstract_french:     { type: 'string', analyzer: 'french_analyzer' },
            abstract_portuguese: { type: 'string', analyzer: 'portuguese_analyzer' },
            abstract_spanish:    { type: 'string', analyzer: 'spanish_analyzer' },

            source_created_at:   { type: 'date', format: 'YYYY-MM-dd' },
            source_updated_at:   { type: 'date', format: 'YYYY-MM-dd' },
            source:              { type: 'string', analyzer: 'keyword' },
            url:                 { type: 'string' },
            source_id:           { type: 'integer' },

            issue_ids:           { type: 'integer' },
            solution_ids:        { type: 'integer' },
            regulation_ids:      { type: 'integer' },

            # For ProviderSolution documents:
            provider_id:         { type: 'integer' },
            solution_id:         { type: 'integer' },
            provider_name:       { type: 'string', analyzer: 'keyword' },
            solution_name:       { type: 'string', analyzer: 'keyword' },
          },
        },
      }.merge(klass.metadata_mappings).freeze

      klass.class_eval do
        class << self
          attr_accessor :source
        end
      end
    end
  end
end
