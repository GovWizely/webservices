module SalesforceArticle
  module Mappable
    def self.included(klass)
      klass.analyze_by :snowball_asciifolding_nostop

      klass.settings.freeze

      klass.mappings = {
        klass.name.typeize => {
          _timestamp: {
            enabled: true,
            store:   true,
          },
          properties: {
            agreement_description:   { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            agreement_status:        { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            agreement_type:          { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            approval_date:           { type: 'date', format: 'YYYY-MM-dd' },

            approval_status:         { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            approver:                { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            article_expiration_date: { type: 'date', format: 'YYYY-MM-dd' },

            atom:                    { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            business_unit:           { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            chapter:                 { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            content:                 { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            first_published_date:    { type: 'date', format: 'YYYY-MM-dd' },
            last_published_date:     { type: 'date', format: 'YYYY-MM-dd' },

            lead_dmo:                { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            notes:                   { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            public_url:              { type: 'string', index: 'not_analyzed' },

            references:              { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            section:                 { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            subject:                 { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            summary:                 { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            support_dmo:             { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            tara_document_title:     { type: 'string', analyzer: 'snowball_asciifolding_nostop' },
            title:                   { type: 'string', analyzer: 'snowball_asciifolding_nostop' },

            url_name:                { type: 'string', index: 'not_analyzed' },
            source:                  { type: 'string', index: 'not_analyzed' },

            countries:               { type: 'string', index: 'not_analyzed' },
            industries:              { type: 'string', index: 'not_analyzed' },
            topics:                  { type: 'string', index: 'not_analyzed' },
            trade_regions:           { type: 'string', index: 'not_analyzed' },
            world_regions:           { type: 'string', index: 'not_analyzed' },
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
