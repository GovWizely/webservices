class ParatureFaq
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
      parature_faq: {
          dynamic: false,
          properties: {

              question: { type: 'string' },
              answer: { type: 'string' },
              id: { type: 'string', index: :not_analyzed, include_in_all: false }
          }
      }
  }.freeze

	end