module ScreeningList
  module Mappable
    def self.included(klass)
      klass.analyze_by :snowball_asciifolding_nostop, :standard_asciifolding_nostop, :keyword_asciifolding_lowercase, :keyword_asciifolding_uppercase

      klass.settings.freeze

      klass.mappings = {
        klass.name.typeize => {
          properties: {
            _updated_at:                { type: 'date', format: 'dateOptionalTime' },
            # name variants
            name:                       { type:     'string',
                                          analyzer: 'standard_asciifolding_nostop',
                                          fields:   {
                                            keyword: { type: 'string', analyzer: 'keyword_asciifolding_lowercase' } } },

            name_idx:                   { type:     'string',
                                          analyzer: 'standard_asciifolding_nostop',
                                          fields:   {
                                            keyword: { type: 'string', analyzer: 'keyword_asciifolding_lowercase' } } },

            alt_names:                  { type:     'string',
                                          analyzer: 'standard_asciifolding_nostop',
                                          fields:   {
                                            keyword: { type: 'string', analyzer: 'keyword_asciifolding_lowercase' } } },

            alt_idx:                    { type:     'string',
                                          analyzer: 'standard_asciifolding_nostop',
                                          fields:   {
                                            keyword: { type: 'string', analyzer: 'keyword_asciifolding_lowercase' } } },

            # reversed
            name_rev:                   { type:     'string',
                                          analyzer: 'standard_asciifolding_nostop',
                                          fields:   {
                                            keyword: { type: 'string', analyzer: 'keyword_asciifolding_lowercase' } } },

            alt_rev:                    { type:     'string',
                                          analyzer: 'standard_asciifolding_nostop',
                                          fields:   {
                                            keyword: { type: 'string', analyzer: 'keyword_asciifolding_lowercase' } } },

            # whitespace removed
            name_no_ws:                 { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            name_no_ws_with_common:     { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            alt_no_ws:                  { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            alt_no_ws_with_common:      { type: 'string', analyzer: 'standard_asciifolding_nostop' },

            # whitespace removed and reversed
            name_no_ws_rev:             { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            name_no_ws_rev_with_common: { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            alt_no_ws_rev:              { type: 'string', analyzer: 'standard_asciifolding_nostop' },
            alt_no_ws_rev_with_common:  { type: 'string', analyzer: 'standard_asciifolding_nostop' },

            remarks:                    { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            title:                      { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            type:                       { type: 'string', analyzer: 'keyword_asciifolding_lowercase' },
            source:                     { properties: { full_name: { type: 'string', index: 'no' },
                                                        code:      { type: 'string', analyzer: 'keyword' } } },
            federal_register_notice:    { type: 'string', analyzer: 'keyword' },

            ### Note to self: (I went back and forth so many times that I need a note to break me out of this loop)
            # uppercase is relevant here because
            addresses:                  { properties: { country:         { type: 'string', analyzer: 'keyword_asciifolding_uppercase' } } },
            # we currently use both filter/term and query/match on this field using different parameters (countries and address,
            # respectively) and we want the query/match not to care about casing.
            # This ensures the query gets analyzed and uppercased during search and the existing terms filter can remain as is.
            # I could mention that I intend to move those filter to use the filter/query but I won't. That might never happen :-P
            ###
            ids:                        { properties: { country:         { type: 'string', analyzer: 'keyword' },
                                                        issue_date:      { type: 'date',   format: 'YYYY-MM-dd' },
                                                        expiration_date: { type: 'date',   format: 'YYYY-MM-dd' } } },

            nationalities:              { type: 'string', analyzer: 'keyword' },
            citizenships:               { type: 'string', analyzer: 'keyword' },
            dates_of_birth:             { type: 'string', analyzer: 'keyword' },
            start_date:                 { type: 'date',   format: 'YYYY-MM-dd' },
            end_date:                   { type: 'date',   format: 'YYYY-MM-dd' },

            entity_number:              { type: 'integer' },
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
