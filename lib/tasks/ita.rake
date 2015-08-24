namespace :ita do
  desc 'Import data for a given comma-separated list of modules containing importers, or importer classes.'
  task :import, [:arg] => :environment do |_t, args|
    args.to_a.each do |module_or_importer_class_name|
      module_or_importer_class = module_or_importer_class_name.constantize
      module_or_importer_class.try(:import_all_sources) || ImportWorker.perform_async(module_or_importer_class_name)
    end
  end

  desc 'Import data for a given importer without firing off a Sidekiq job'
  task :import_synchronously, [:importer_class_name] => :environment do |_t, args|
    importer_class = args.importer_class_name.constantize
    fail 'Give me an Importable class please.' unless importer_class.include?(Importable)
    importer_class.new.import
  end

  desc 'Recreate indices for a given comma-separated list of modules containing importers, or importer classes.'
  task :recreate_index, [:arg] => :environment do |_t, args|
    args.to_a.each do |module_or_importer_class_name|
      module_or_importer_class = module_or_importer_class_name.constantize
      importers = module_or_importer_class.try(:importers) || [module_or_importer_class]
      importers.each { |i| i.new.model_class.recreate_index }
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
end
