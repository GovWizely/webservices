module ModelBuilder
  TEMPLATE_PATH = 'lib/elasticsearch/templates/document.rb.erb'.freeze
  TYPE_TO_MAPPING = { enum:    { type: String, mapping: { type: 'string', analyzer: 'keyword_lowercase' } },
                      integer: { type: Integer, mapping: { type: 'long' } },
                      float:   { type: Float },
                      date:    { type: DateTime },
                      string:  { type: String, mapping: { type: 'string', analyzer: 'snowball_asciifolding_nostop' } } }.with_indifferent_access

  def self.load_model_class(data_source)
    template = ERB.new(Rails.root.join(TEMPLATE_PATH).read, nil, '<>').result(binding)
    eval(template, binding, __FILE__, __LINE__)
  end
end
