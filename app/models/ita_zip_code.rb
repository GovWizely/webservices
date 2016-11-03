class ItaZipCode
  include Indexable

  SYNONYMS = ['ft, fort', 'st, saint']
  STOPWORDS = %w(US Export Assistance Center USEAC Commercial Service Mission)

  self.import_rate = 'Daily'
  self.settings = {
    index: {
      analysis: {
        analyzer: {
          case_insensitive_keyword_analyzer: {
            tokenizer: 'keyword',
            filter:    %w(standard lowercase), },
          location_name_analyzer:            {
            tokenizer: 'standard',
            filter:    %w(standard asciifolding lowercase synonym stopword), },
          location_name_sort:                {
            tokenizer: 'keyword',
            filter:    %w(lowercase asciifolding), },
        },
        filter:   {
          synonym:  { type:     'synonym',
                      synonyms: SYNONYMS, },
          stopword: { type:        'stop',
                      ignore_case: true,
                      stopwords:   STOPWORDS.join(','), },
        },
      },
    },
  }.freeze

  self.mappings = {
    name.typeize => {
      dynamic:    'false',
      properties: {
        _updated_at:       { type: 'date', format: 'strictDateOptionalTime' },
        zip_code:          { type: 'string' },
        zip_city:          { type: 'string', analyzer: 'location_name_analyzer' },
        post:              {
          type:     'string',
          analyzer: 'location_name_analyzer',
          fields:   {
            sort: { type: 'string', analyzer: 'location_name_sort' }, }, },
        office_name:       { type: 'string', analyzer: 'location_name_analyzer' },
        country:           { type: 'string', analyzer: 'case_insensitive_keyword_analyzer' },
        state:             { type: 'string', analyzer: 'case_insensitive_keyword_analyzer' },
        post_city:         { type: 'string', analyzer: 'location_name_analyzer' },
        email:             { type: 'string' },
        fax:               { type: 'string' },
        mail_instructions: { type: 'string' },
        phone:             { type: 'string' },
        address:           { type: 'string' },
      },
    },
  }.merge(metadata_mappings,).freeze

  self.source = {
    full_name: 'ITA',
    code:      'ITAZC',
  }
end
