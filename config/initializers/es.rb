unless Rails.env.test?
  Webservices::Application.model_classes.each do |model_class|
    model_class.create_index unless model_class.index_exists?
  end
  User.create_index!
end
