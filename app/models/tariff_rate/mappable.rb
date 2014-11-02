module TariffRate
  module Mappable
    def self.included(klass)
      klass.settings = {
        index: {
          analysis: {
            analyzer: {
              snowball_asciifolding_nostop: {
                tokenizer: 'standard',
                filter:    %w(standard asciifolding lowercase snowball),
              },
              keyword_lowercase:            {
                tokenizer: 'keyword',
                filter:    %w(lowercase),
              },
            },
          },
        },
      }.freeze

      klass.mappings = {
        klass.to_s.typeize => {
          properties: {
            id:                          { type: 'integer', index: :not_analyzed, include_in_all: false },
            source_id:                   { type: 'string' },
            tariff_line:                 { type: 'string' },
            description:                 { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            hs_6:                        { type: 'string' },
            sector_code:                 { type: 'string' },
            base_rate:                   { type: 'string', include_in_all: false },
            base_rate_alt:               { type: 'string', include_in_all: false },
            final_year:                  { type: 'string' },
            tariff_lines_per_6_digit:    { type: 'string' },
            tariff_rate_quota:           { type: 'string', include_in_all: false },
            tariff_rate_quota_note:      { type: 'string', analyzer: 'snowball_asciifolding_nostop', include_in_all: false },
            tariff_eliminated:           { type: 'string', analyzer: 'keyword', include_in_all: false },
            product_type_id:             { type: 'string' },
            pending_data:                { type: 'string', analyzer: 'keyword' },
            ag_id:                       { type: 'string', include_in_all: false },
            partner_name:                { type: 'string', analyzer: 'keyword' },
            reporter_name:               { type: 'string', analyzer: 'keyword' },
            staging_basket:              { type: 'string', analyzer: 'keyword' },
            staging_basket_id:           { type: 'string' },
            num_mar_columns:             { type: 'string' },
            partner_start_year:          { type: 'string' },
            reporter_start_year:         { type: 'string', include_in_all: false },
            partner_agreement_name:      { type: 'string', analyzer: 'keyword' },
            reporter_agreement_name:     { type: 'string', analyzer: 'keyword' },
            partner_agreement_approved:  { type: 'string', analyzer: 'keyword', include_in_all: false },
            reporter_agreement_approved: { type: 'string', analyzer: 'keyword', include_in_all: false },
            rule_text:                   { type: 'string', analyzer: 'snowball_asciifolding_nostop', include_in_all: false },
            link_text:                   { type: 'string', analyzer: 'snowball_asciifolding_nostop', include_in_all: false },
            link_url:                    { type: 'string', analyzer: 'snowball_asciifolding_nostop', include_in_all: false },
            quota_name:                  { type: 'string', analyzer: 'keyword', include_in_all: false },
            industrie:                   { type: 'string', analyzer: 'keyword' },
            countries:                   { type: 'string', analyzer: 'keyword' },
            source:                      { type: 'string', analyzer: 'keyword' },
          },
        },
      }.freeze

      klass.class_eval do
        class << self
          attr_accessor :source
        end
      end
    end
  end
end
