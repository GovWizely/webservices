unless Rails.env.test?
  Dir[Rails.root.join('app/models/**/*.rb').to_s].each do |filename|
    klass = filename.gsub(/(^.+models\/|\.rb$)/, '').camelize.constantize
    klass.create_index if klass.is_a?(Indexable) && !klass.index_exists?
  end
end
