require 'orm_adapter/adapters/elasticsearch'
require 'elasticsearch/persistence/model'

Elasticsearch::Persistence::Model::Store::ClassMethods.send(:include, Devise::Models)
Elasticsearch::Persistence::Model::Store::ClassMethods.send(:include, OrmAdapter::ToAdapter)
