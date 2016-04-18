# Rake task to store a local copy of the Webprotege source XML and also store a copy of its geo terms for spec usage.

namespace :taxonomy do
  desc 'Load terms to yaml files'
  task load_data: :environment do
    open(Rails.configuration.full_protege_source, 'wb') { |f| f << open(Rails.configuration.protege_url).read }
    parser = TaxonomyParser.new(Rails.configuration.full_protege_source)
    parser.parse
    File.open(Rails.configuration.full_taxonomy_concepts, 'w') { |f| f.write(parser.concepts.to_yaml) }
  end
end
