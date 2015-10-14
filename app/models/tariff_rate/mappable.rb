module TariffRate
  module Mappable
    def self.included(klass)
      klass.analyze_by :snowball_asciifolding_nostop

      klass.settings.freeze

      klass.mappings = {
        klass.to_s.typeize => {
          properties: {
            source_id:                   { type: 'string' },
            tariff_line:                 { type: 'string' },
            subheading_description:      { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            hs_6:                        { type: 'string' },
            base_rate:                   { type: 'string', include_in_all: false },
            base_rate_alt:               { type: 'string', include_in_all: false },
            final_year:                  { type: 'date', format: 'year' },
            tariff_rate_quota:           { type: 'string', include_in_all: false },
            tariff_rate_quota_note:      { type: 'string', analyzer: 'snowball_asciifolding_nostop', include_in_all: false },
            tariff_eliminated:           { type: 'string', analyzer: 'keyword', include_in_all: false },
            ag_id:                       { type: 'string', include_in_all: false },
            partner_name:                { type: 'string', analyzer: 'keyword' },
            reporter_name:               { type: 'string', analyzer: 'keyword' },
            staging_basket:              { type: 'string', analyzer: 'keyword' },
            partner_start_year:          { type: 'date', format: 'year' },
            reporter_start_year:         { type: 'date', include_in_all: false, format: 'year' },
            partner_agreement_name:      { type: 'string', analyzer: 'keyword' },
            reporter_agreement_name:     { type: 'string', analyzer: 'keyword' },
            partner_agreement_approved:  { type: 'string', analyzer: 'keyword', include_in_all: false },
            reporter_agreement_approved: { type: 'string', analyzer: 'keyword', include_in_all: false },
            rule_text:                   { type: 'string', analyzer: 'snowball_asciifolding_nostop', include_in_all: false },
            link_text:                   { type: 'string', analyzer: 'snowball_asciifolding_nostop', include_in_all: false },
            link_url:                    { type: 'string', analyzer: 'snowball_asciifolding_nostop', include_in_all: false },
            quota_name:                  { type: 'string', analyzer: 'keyword', include_in_all: false },
            source:                      { type: 'string', analyzer: 'keyword' },
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
