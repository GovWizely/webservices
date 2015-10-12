DataSource.create_index!
DataSource.all.each do |data_source|
  klass_symbol = data_source.api.classify.to_sym
  klass = ModelBuilder.load_model_class data_source
  Object.const_set(klass_symbol, klass)
end