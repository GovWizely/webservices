namespace :taxonomy do
  desc 'Load geo terms to yaml file'
  task load_geo_terms: :environment do
    open(Rails.configuration.frozen_protege_source, 'wb') { |f| f << open(Rails.configuration.protege_url).read }
    parser = TaxonomyParser.new(Rails.configuration.frozen_protege_source)
    parser.parse
    File.open(Rails.configuration.frozen_taxonomy_concepts, 'w') { |f| f.write(parser.concepts.to_yaml) }
  end
end
