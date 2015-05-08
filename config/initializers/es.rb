unless Rails.env.test?
  Webservices::Application.model_classes.each do |model_class|
    begin
      model_class.create_index unless model_class.index_exists?

    # In dev envs, a race condition between the web server and sidekiq can
    # cause this code to attempt to create an index which already exists
    # (recently brought into existence by the other). We therefore silently
    # ignore such a failure.
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      raise unless e.message =~ /IndexAlreadyExistsException/
    end
  end
  User.create_index!
end
