class ImportEmptyIndices
  class << self
    # Imports all model classes which have empty indices.
    # Returns lists of model classes it imported.
    def call(dry_run: false)
      Webservices::Application.model_classes.select do |model_class|
        search = ES.client.search(index: model_class.index_name, type: model_class.index_type)
        importer_class = model_class.importer_class

        if import?(importer_class) && search['hits']['total'] == 0
          Rails.logger.info("Importing #{model_class} as its index is empty")
          ImportWorker.perform_async(importer_class.name) unless dry_run
          true
        else
          false
        end
      end
    end

    private

    def import?(importer_class)
      !importer_class.disabled?
    end
  end
end
