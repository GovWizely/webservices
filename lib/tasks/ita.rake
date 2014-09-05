namespace :ita do
  desc 'Import data for a given index'
  task :import, [:index_name] => :environment do |t, args|
    import_data(args.index_name)
  end

  desc 'Recreate an index'
  task :recreate_index, [:index_name] => :environment do |t, args|
    args.index_name.constantize.recreate_index
  end

  desc 'Recreate then import all CSL indices'
  task :recreate_then_import_csl_indices => :environment do
    %w( BisDeniedPerson
        BisEntity
        BisUnverifiedParty
        BisnForeignSanctionsEvader
        BisnNonproliferationSanction
        DdtcAecaDebarredParty
        OfacSpecialDesignatedNational
      ).each do |class_name|
      class_name.constantize.recreate_index
      import_data(class_name)
    end
  end

  desc 'Recreate then import all Trade Lead indices'
  task :recreate_then_import_trade_lead_indices => :environment do
    %w( CanadaLead
        StateTradeLead
        UkTradeLead
      ).each do |class_name|
      class_name.constantize.recreate_index
      import_data(class_name)
    end
  end

  def import_data(model_class_name)
    "#{model_class_name}Data".constantize.new.import
  end
end
