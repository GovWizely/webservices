namespace :envirotech do
  desc 'Update issue_solution_regulation.json file with latest data from toolkit scraper'
  task update_local_relational_data: :environment do
    $stdout.reopen("data/envirotech/issue_solution_regulation.json", "w")
    puts JSON.pretty_generate(Envirotech::ToolkitScraper.new.all_issue_info)
  end
end
