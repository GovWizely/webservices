class ItaZipCode
  include Indexable

  SYNONYMS = ['ft, fort', 'st, saint']
  STOPWORDS = %w(US Export Assistance Center USEAC Commercial Service Mission)

  self.settings = ItaOfficeLocation.settings

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
            sort: { type: 'string', analyzer: 'location_name_sort' } } },
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
  }.merge(metadata_mappings).freeze

  self.source = {
    full_name: 'ITA',
    code:      'ITAZC',
  }
end
