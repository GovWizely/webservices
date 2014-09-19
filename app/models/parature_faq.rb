class ParatureFaq
	extend Indexable


  self.settings = {
      index: {
          analysis: {
              analyzer: {
                  custom_analyzer: {
                      type: 'custom',
                      char_filter: 'html_strip',
                      tokenizer: 'standard',
                      filter: %w(standard lowercase) }
              }
          }
      }
  }.freeze

  self.mappings = {
      parature_faq: {
          dynamic: false,
          properties: {
              question: { type: 'string'},
              answer: { type: 'string' },
              published: {type: 'boolean'},
              create_date: {type: 'date', format: 'YYYY-MM-dd' },
              update_date: {type: 'date', format: 'YYYY-MM-dd' },
              user_rating: {type: 'integer'},
              topic:  {type: 'string' },
              industry:  {type: 'string' },
              country:  {type: 'string' },
              id: { type: 'string', index: :not_analyzed, include_in_all: false }
          }
      }
  }.freeze

	end