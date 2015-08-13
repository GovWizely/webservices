class ItaOfficeLocation
  include Indexable

  SYNONYMS = ['ft, fort', 'st, saint']
  STOPWORDS = %w(US Export Assistance Center USEAC Commercial Service Mission)

  self.settings = {
    index: {
      analysis: {
        analyzer: {
          case_insensitive_keyword_analyzer: {
            tokenizer: 'keyword',
            filter:    %w(standard lowercase) },
          location_name_analyzer:            {
            tokenizer: 'standard',
            filter:    %w(standard asciifolding lowercase synonym stopword) },
          location_name_sort:                {
            tokenizer: 'keyword',
            filter:    %w(lowercase asciifolding) },
        },
        filter:   {
          synonym:  { type:     'synonym',
                      synonyms: SYNONYMS },
          stopword: { type:        'stop',
                      ignore_case: true,
                      stopwords:   STOPWORDS.join(',') },
        },
      },
    },
  }.freeze

  self.mappings = {
    name.typeize => {
      dynamic:    'false',
      properties: {
        post:        {
          type:     'string',
          analyzer: 'location_name_analyzer',
          fields:   {
            sort: { type: 'string', analyzer: 'location_name_sort' } } },
        office_name: { type: 'string', analyzer: 'location_name_analyzer' },
        country:     { type: 'string', analyzer: 'case_insensitive_keyword_analyzer' },
        state:       { type: 'string', analyzer: 'case_insensitive_keyword_analyzer' },
        city:        { type: 'string', analyzer: 'location_name_analyzer' },
      },
    },
  }.freeze

  self.source = {
    full_name: 'ITA',
    code:      'ITAOL',
  }
end
