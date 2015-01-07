namespace :ita do
  desc 'Import data for a given module containing models, or a given model class'
  task :import, [:module_or_model_class] => :environment do |_t, args|
    importers(args.module_or_model_class.constantize).each do |i|
      i.new.import_and_if_possible_purge_old
    end
  end

  desc 'Recreate indices for a given module containing models, or a given model class'
  task :recreate_index, [:module_or_model_class] => :environment do |_t, args|
    importers(args.module_or_model_class.constantize).each do |i|
      i.new.model_class.recreate_index
    end
  end

  desc 'Recreate indices that have had their Model.mappings modified'
  task recreate_indices_with_modified_mappings: :environment do
    RecreateIndicesWithModifiedMappings.call
  end

  desc 'Recreate indices that have had their Model.mappings modified'
  task import_empty_indices: :environment do
    ImportEmptyIndices.call
  end

  def importers(module_or_model_class)
    if module_or_model_class.is_a?(Indexable)
      model_class = module_or_model_class
      [model_class.importer_class]
    else
      modu1e = module_or_model_class
      module_importer_files =
        "#{Rails.root}/app/importers/#{modu1e.name.typeize}/*"
      Dir[module_importer_files].each { |f| require f }

      modu1e.constants
        .map { |constant| modu1e.const_get(constant) }
        .select { |klass| klass.include?(Importer) }
    end
  end
end
