module ModelBuilder
  TEMPLATE_PATH = 'lib/elasticsearch/templates/document.rb.erb'.freeze
  TYPE_TO_MAPPING = { enum: { type: String, mapping: { type: 'string', index: 'not_analyzed' } },
                      integer: { type: Integer },
                      float: { type: Float },
                      date: { type: DateTime },
                      string: { type: String, mapping: { type: 'string', analyzer: 'english' } } }.with_indifferent_access

  def self.load_model_class(data_source)
    template = ERB.new(Rails.root.join(TEMPLATE_PATH).read, nil, '<>').result(binding)
    Rails.logger.info "template:\n#{template}"
    eval template, binding, __FILE__, __LINE__
  end
end
