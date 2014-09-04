class ItaOfficeLocation
  extend Indexable

  SYNONYMS = ["ft, fort", "st, saint"]
  STOPWORDS = %w(US Export Assistance Center USEAC Commercial Service Mission)

  self.settings = {
      index: {
          analysis: {
              analyzer: {
                  case_insensitive_keyword_analyzer: {
                      tokenizer: 'keyword',
                      filter: %w(standard lowercase) },
                  location_name_analyzer: {
                      tokenizer: 'standard',
                      filter: %w(standard asciifolding lowercase synonym stopword) },
                  location_name_sort: {
                      tokenizer: 'keyword',
                      filter: %w(lowercase asciifolding) }
              },
              filter: {
                  synonym: { type: 'synonym',
                             synonyms: SYNONYMS },
                  stopword: { type: 'stop',
                              ignore_case: true,
                              stopwords: STOPWORDS.join(',') }
              }
          }
      }
  }.freeze

  self.mappings = {
      ita_office_location: {
          dynamic: false,
          properties: {
              post: { type: 'multi_field',
                      fields: {
                          post: { type: 'string', analyzer: 'location_name_analyzer' },
                          sort: { type: 'string', analyzer: 'location_name_sort' } } },
              office_name: { type: 'string', analyzer: 'location_name_analyzer' },
              country: { type: 'string', analyzer: 'case_insensitive_keyword_analyzer' },
              state: { type: 'string', analyzer: 'case_insensitive_keyword_analyzer' },
              city: { type: 'string', analyzer: 'location_name_analyzer' },
              id: { type: 'string', index: :not_analyzed, include_in_all: false }
          }
      }
  }.freeze
end
