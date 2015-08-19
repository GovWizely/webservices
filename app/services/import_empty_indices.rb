class ImportEmptyIndices
  class << self
    # Imports all model classes which have empty indices.
    # Returns lists of model classes it imported.
    def call(options = {})
      dry_run = options.deep_symbolize_keys.fetch(:dry_run, false)

      Webservices::Application.model_classes.select do |model_class|
        search = ES.client.search(index: model_class.index_name, type: model_class.index_type)

        if search['hits']['total'] == 0
          Rails.logger.info("Importing #{model_class} as its index is empty")
          importer = model_class.importer_class
          ImportWorker.perform_async(importer.name) unless dry_run || importer.disabled?
          true
        else
          false
        end
      end
    end
  end
end
