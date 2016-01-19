namespace :taxonomy do
  desc 'Load geo terms to yaml file'
  task load_geo_terms: :environment do
    parser = TaxonomyParser.new("#{Rails.root}/data/webprotege.zip")
    parser.parse
    File.open("#{Rails.root}/data/taxonomy/concepts.yaml", 'w') { |f| f.write(parser.concepts.to_yaml) }
  end
end
