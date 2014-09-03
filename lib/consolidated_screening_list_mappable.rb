module ConsolidatedScreeningListMappable

  def self.included(klass)
    klass.settings = {
      index: {
        analysis: {
          analyzer: {
            snowball_asciifolding_nostop: {
              tokenizer: 'standard',
              filter: %w(standard asciifolding lowercase snowball)
            },
            keyword_lowercase: {
              tokenizer: 'keyword',
              filter: %w(lowercase)
            }
          }
        }
      }
    }.freeze

    klass.mappings = {
      klass.to_s.underscore => {
        properties: {
          id:        { type: 'integer', index: :not_analyzed, include_in_all: false },

          name:      { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
          alt_names: { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
          remarks:   { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
          title:     { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

          sdn_type:  { type: 'string', analyzer: 'keyword_lowercase' },
          source:    { type: 'string', analyzer: 'keyword' },

          addresses: { properties: { country:         { type: 'string', analyzer: 'keyword' } } },
          ids:       { properties: { country:         { type: 'string', analyzer: 'keyword' },
                                     issue_date:      { type: 'date',   format: 'YYYY-MM-dd' },
                                     expiration_date: { type: 'date',   format: 'YYYY-MM-dd' } } },

          nationalities:  { type: 'string', analyzer: 'keyword' },
          citizenships:   { type: 'string', analyzer: 'keyword' },
          dates_of_birth: { type: 'date',   format: 'YYYY-MM-dd' },
          start_date:     { type: 'date',   format: 'YYYY-MM-dd' },
          end_date:       { type: 'date',   format: 'YYYY-MM-dd' },

          entity_number:  { type: 'integer' },
        }
      }
    }.freeze

    klass.class_eval do
      class << self
        attr_accessor :source
      end
    end
  end
end
