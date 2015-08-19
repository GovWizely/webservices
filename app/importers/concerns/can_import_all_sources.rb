module CanImportAllSources
  extend ActiveSupport::Concern

  module ClassMethods
    def importers
      module_importer_files =
        "#{Rails.root}/app/importers/#{name.typeize}/*"
      Dir[module_importer_files].each { |f| require f }

      constants
        .map { |constant| const_get(constant) }
        .select { |klass| klass.include?(Importable) && !klass.disabled? }
    end

    def import_all_sources
      importers.each do |i|
        ImportWorker.perform_async(i.name)
      end
      true
    end
  end
end
