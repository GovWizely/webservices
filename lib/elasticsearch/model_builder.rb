module ModelBuilder
  TEMPLATE_PATH = 'lib/elasticsearch/templates/document.rb.erb'.freeze
  TYPE_TO_MAPPING = { enum:    { type: String, mapping: { type: 'string', index: 'not_analyzed' } },
                      integer: { type: Integer },
                      float:   { type: Float },
                      date:    { type: DateTime },
                      string:  { type: String, mapping: { type: 'string', analyzer: 'english' } } }.with_indifferent_access

  def self.load_model_class(data_source)
    template = ERB.new(Rails.root.join(TEMPLATE_PATH).read, nil, '<>').result(binding)
    klass = eval(template, binding, __FILE__, __LINE__)
    klass_symbol = data_source.api.classify.to_sym
    Webservices::ApiModels.send(:remove_const, klass_symbol) if Webservices::ApiModels.constants.include?(klass_symbol)
    Webservices::ApiModels.const_set(klass_symbol, klass)
    klass
  end
end
