module Haml::Filters
  remove_filter 'Markdown'

  module Markdown
    include Haml::Filters::Base

    def render(text)
      Kramdown::Document.new(text, input: 'GFM').to_html
    end
  end
end
