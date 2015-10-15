namespace :urls do
  desc 'Recreate URL Mappings index'
  task recreate_index: :environment do
    UrlMapper.recreate_index
  end

  desc 'Purge old entries'
  task purge_old: :environment do
    UrlMapper.purge_old
  end
end
