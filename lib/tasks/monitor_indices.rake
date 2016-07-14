namespace :monitor_indices do
  desc 'Ensure indices with Sidekiq importers are refreshing'
  task run: :environment do
    IndexMonitor.new.check_indices
  end
end
