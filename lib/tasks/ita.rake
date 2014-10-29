namespace :ita do
  desc 'Import data for a given module containing models, or a given model class'
  task :import, [:module_or_model_class] => :environment do |_t, args|
    importers(args.module_or_model_class.constantize).each { |i| do_import(i.new) }
  end

  desc 'Recreate indices for a given module containing models, or a given model class'
  task :recreate_index, [:module_or_model_class] => :environment do |_t, args|
    importers(args.module_or_model_class.constantize).each do |i|
      i.new.model_class.recreate_index
    end
  end

  def importers(module_or_model_class)
    if module_or_model_class.is_a?(Indexable)
      model_class = module_or_model_class
      ["#{model_class.name}Data".constantize]
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

  def do_import(importer)
    if importer.can_purge_old?
      importer.import_then_purge_old
    else
      importer.import
    end
  end
end
