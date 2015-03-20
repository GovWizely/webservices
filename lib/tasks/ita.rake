namespace :ita do
  desc 'Import data for a given comma-separated list of modules containing importers, or importer classes.'
  task :import, [:arg] => :environment do |_t, args|
    args.to_a.each do |module_or_importer_class_name|
      importers(module_or_importer_class_name).each do |i|
        i.new.import_and_if_possible_purge_old
      end
    end
  end

  desc 'Recreate indices for a given comma-separated list of modules containing importers, or importer classes.'
  task :recreate_index, [:arg] => :environment do |_t, args|
    args.to_a.each do |module_or_importer_class_name|
      importers(module_or_importer_class_name).each do |i|
        i.new.model_class.recreate_index
      end
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

  def importers(module_or_importer_class_name)
    module_or_importer_class = module_or_importer_class_name.constantize
    if module_or_importer_class.include?(Importer)
      [module_or_importer_class]
    else
      module_or_importer_class.importers
    end
  end
end
