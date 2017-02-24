module ScreeningList
  module Mappable
    def self.included(klass)
      klass.import_rate = 'Hourly'
      klass.analyze_by :snowball_asciifolding_nostop, :standard_asciifolding_nostop, :keyword_asciifolding_lowercase, :keyword_asciifolding_uppercase

      klass.settings.freeze

      klass.mappings = {
        klass.name.typeize => {
          properties: {
            _updated_at:                { type: 'date', format: 'strictDateOptionalTime' },
            # base names
            name:                       { type:        'text',
                                          term_vector: 'with_positions_offsets',
                                          analyzer:    'standard_asciifolding_nostop',
                                          fields:      {
                                            keyword: { type: 'keyword' }, }, },
            name_idx:                   { type:        'text',
                                          term_vector: 'with_positions_offsets',
                                          analyzer:    'standard_asciifolding_nostop',
                                          fields:      {
                                            keyword: { type: 'text', analyzer: 'keyword_asciifolding_lowercase' }, }, },
            alt_names:                  { type:        'text',
                                          term_vector: 'with_positions_offsets',
                                          analyzer:    'standard_asciifolding_nostop',
                                          fields:      {
                                            keyword: { type: 'text', analyzer: 'keyword_asciifolding_lowercase' }, }, },
            alt_idx:                    { type:        'text',
                                          term_vector: 'with_positions_offsets',
                                          analyzer:    'standard_asciifolding_nostop',
                                          fields:      {
                                            keyword: { type: 'text', analyzer: 'keyword_asciifolding_lowercase' }, }, },
            # reversed
            name_rev:                   { type:        'text',
                                          term_vector: 'with_positions_offsets',
                                          analyzer:    'standard_asciifolding_nostop',
                                          fields:      {
                                            keyword: { type: 'text', analyzer: 'keyword_asciifolding_lowercase' }, }, },

            alt_rev:                    { type:        'text',
                                          term_vector: 'with_positions_offsets',
                                          analyzer:    'standard_asciifolding_nostop',
                                          fields:      {
                                            keyword: { type: 'text', analyzer: 'keyword_asciifolding_lowercase' }, }, },
            # whitespace removed
            name_no_ws:                 { type: 'text', analyzer: 'standard_asciifolding_nostop',
                                          term_vector: 'with_positions_offsets', },
            name_no_ws_with_common:     { type: 'text', analyzer: 'standard_asciifolding_nostop',
                                          term_vector: 'with_positions_offsets', },
            alt_no_ws:                  { type: 'text', analyzer: 'standard_asciifolding_nostop',
                                          term_vector: 'with_positions_offsets', },
            alt_no_ws_with_common:      { type: 'text', analyzer: 'standard_asciifolding_nostop',
                                          term_vector: 'with_positions_offsets', },

            # whitespace removed and reversed
            name_no_ws_rev:             { type: 'text', analyzer: 'standard_asciifolding_nostop',
                                          term_vector: 'with_positions_offsets', },
            name_no_ws_rev_with_common: { type: 'text', analyzer: 'standard_asciifolding_nostop',
                                          term_vector: 'with_positions_offsets', },
            alt_no_ws_rev:              { type: 'text', analyzer: 'standard_asciifolding_nostop',
                                          term_vector: 'with_positions_offsets', },
            alt_no_ws_rev_with_common:  { type: 'text', analyzer: 'standard_asciifolding_nostop',
                                          term_vector: 'with_positions_offsets', },

            remarks:                    { type: 'text', analyzer: 'snowball_asciifolding_nostop' },
            title:                      { type: 'text', analyzer: 'snowball_asciifolding_nostop' },

            type:                       { type: 'text', analyzer: 'keyword_asciifolding_lowercase' },
            source:                     { properties: { full_name: { type: 'text', index: false },
                                                        code:      { type: 'keyword' }, }, },
            federal_register_notice:    { type: 'keyword' },

            ### Note to self: (I went back and forth so many times that I need a note to break me out of this loop)
            # uppercase is relevant here because
            addresses:                  { properties: { country:         { type: 'text', analyzer: 'keyword_asciifolding_uppercase' } } },
            # we currently use both filter/term and query/match on this field using different parameters (countries and address,
            # respectively) and we want the query/match not to care about casing.
            # This ensures the query gets analyzed and uppercased during search and the existing terms filter can remain as is.
            # I could mention that I intend to move those filter to use the filter/query but I won't. That might never happen :-P
            ###
            ids:                        { properties: { country:         { type: 'keyword' },
                                                        issue_date:      { type: 'date',   format: 'YYYY-MM-dd' },
                                                        expiration_date: { type: 'date',   format: 'YYYY-MM-dd' }, }, },

            nationalities:              { type: 'keyword' },
            citizenships:               { type: 'keyword' },
            dates_of_birth:             { type: 'keyword' },
            start_date:                 { type: 'date',   format: 'YYYY-MM-dd' },
            end_date:                   { type: 'date',   format: 'YYYY-MM-dd' },
            country:                    { type: 'keyword' },
            entity_number:              { type: 'integer' },
          },
        },
      }.merge(klass.metadata_mappings,).freeze

      klass.class_eval do
        class << self
          attr_accessor :source
        end
      end
    end
  end
end
