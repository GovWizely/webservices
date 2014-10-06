class SharepointTradeArticle
  extend Indexable

  self.settings = {
    index: {
      analysis: {
        analyzer:
                  { custom_analyzer:              {
                    tokenizer: 'standard',
                    filter:    %w(standard asciifolding lowercase snowball) },
                    description_keyword_analyzer: {
                      tokenizer: 'keyword',
                      filter:    %w(asciifolding lowercase) },
            },
      },
    },
  }.freeze

  self.mappings = {
    sharepoint_trade_article: {
      properties: {
        id:          { type: 'string', index: :not_analyzed, include_in_all: false },
        title: { type: 'string', analyzer: 'custom_analyzer' },
        short_title: { type: 'string', analyzer: 'custom_analyzer' },
        summary: { type: 'string', analyzer: 'custom_analyzer' },
        creation_date: { type: 'date', format: "YYYY-MM-dd" },
        release_date: { type: 'date', format: "YYYY-MM-dd" },
        expiration_date: { type: 'date', format: "YYYY-MM-dd" },
        #source_agencies: { type: 'string' },
        evergreen: { type: 'boolean' },
        content: { type: 'string' },
        keyword: { type: 'string' },
        #ita_tags:        { type:   'multi_field',
        #               fields: {
        #                 export_phases: { type: 'string' },
        #                 industries: { type: 'string' } ,
        #                  countries: { type: 'string' },
        #                  trade_regions: { type: 'string' },
        #                  trade_programs: { type: 'string' },
        #                  trade_initiatives: { type: 'string' }
        #               } },
        seo_metadata_title: { type: 'string' },
        seo_metadata_description: { type: 'string' },
        seo_metadata_keyword: { type: 'string' },
        trade_url: { type: 'string' },
        file_url: { type: 'string' },
        image_url: { type: 'string' },
        url_html_source: { type: 'string' },
        url_xml_source: { type: 'string' }
      },
    },
  }.freeze
end