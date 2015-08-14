require 'pp'
namespace :envirotech do
  desc 'Creates a dev admin user to access the api'
  task :lookup_issue, [:issue_name] => :environment do |_t, args|
    puts Envirotech::ToolkitScraper.new.fetch_issue_info(args.issue_name)
  end

  task all_issue_info: :environment do
    pp Envirotech::ToolkitScraper.new.all_issue_info
  end
end
