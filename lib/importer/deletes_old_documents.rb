module Importer
  module DeletesOldDocuments
    def self.prepended(base)
      ensure_importer_included(base)
      ensure_model_can_delete_old_documents(base)
    end

    def import
      start_time = Time.now
      super
      model_class.delete_old_documents(start_time)
    end

    private

    def self.ensure_importer_included(base)
      importer_included = base.included_modules.find { |a| a.name == 'Importer' }
      unless importer_included
        fail 'Must include Importer'
      end
    end

    def self.ensure_model_can_delete_old_documents(base)
      model_can_delete_old_documents =
        base.model_class.singleton_class.included_modules.find do |m|
          m.name == 'Model::CanDeleteOldDocuments'
        end
      unless model_can_delete_old_documents
        fail "model_class #{base.model_class.name} must extend Model::CanDeleteOldDocuments"
      end
    end
  end
end
