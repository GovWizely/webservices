namespace :db do
  desc 'Create all endpoint and user indices'
  task create: :environment do
    MetadataRepository.create_index! unless MetadataRepository.index_exists?
    Webservices::Application.model_classes.each do |model_class|
      model_class.create_index unless model_class.index_exists?
      model_class.find_or_create_metadata
    end
    UrlMapper.create_index unless UrlMapper.index_exists?
    User.create_index!
  end

  desc 'Delete all indices relating to this project and environment'
  task drop: :environment do
    ES.client.indices.delete(index: [ES::INDEX_PREFIX, '*'].join(':'))
  end
end
