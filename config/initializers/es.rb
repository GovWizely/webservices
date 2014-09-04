unless Rails.env.test?
  Dir[Rails.root.join('app/models/*.rb').to_s].each do |filename|
    klass = File.basename(filename, '.rb').camelize.constantize
    klass.create_index if klass.kind_of?(Indexable) and not klass.index_exists?
  end
end
