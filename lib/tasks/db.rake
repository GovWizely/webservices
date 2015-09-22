namespace :db do
  desc 'Create all endpoint and user indices'
  task create: :environment do
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

  desc 'Delete all indices relating to this project and environment'
  task drop: :environment do
    ES.client.indices.delete(index: [ES::INDEX_PREFIX, '*'].join(':'))
  end
end
