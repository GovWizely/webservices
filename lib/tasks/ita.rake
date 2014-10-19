namespace :ita do
  desc 'Import data for a given index'
  task :import, [:model_class_name] => :environment do |_t, args|
    do_import(args.model_class_name)
  end

  desc 'Recreate an index'
  task :recreate_index, [:model_class_name] => :environment do |_t, args|
    args.model_class_name.constantize.recreate_index
  end

  desc 'Recreate then import all CSL indices'
  task recreate_then_import_csl_indices: :environment do
    %w( ScreeningList::Dpl
        ScreeningList::Dtc
        ScreeningList::El
        ScreeningList::Fse
        ScreeningList::Isn
        ScreeningList::Plc
        ScreeningList::Sdn
        ScreeningList::Ssi
        ScreeningList::Uvl
    ).each do |class_name|
      class_name.constantize.recreate_index
      do_import(class_name)
    end
  end

  desc 'Recreate then import all Trade Lead indices'
  task recreate_then_import_trade_lead_indices: :environment do
    %w( CanadaLead
        FbopenLead
        StateTradeLead
        UkTradeLead
    ).each do |class_name|
      class_name.constantize.recreate_index
      do_import(class_name)
    end
  end

  def do_import(model_class_name)
    importer = "#{model_class_name}Data".constantize.new
    if importer.can_purge_old?
      importer.import_then_purge_old
    else
      importer.import
    end
  end
end
