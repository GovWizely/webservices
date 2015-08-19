module CanImportAllSources
  extend ActiveSupport::Concern
  # This module can be used to extend a module which contains importer classes.
  # It adds a module method which returns the list of importers that the module
  # contains.

  module ClassMethods
    def importers
      module_importer_files =
        "#{Rails.root}/app/importers/#{name.typeize}/*"
      Dir[module_importer_files].each { |f| require f }

      constants
        .map { |constant| const_get(constant) }
        .select { |klass| klass.include?(Importable) }
    end
  end
end
