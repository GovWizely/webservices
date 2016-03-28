# Rake task to store a local copy of the Webprotege source XML and also store a copy of its concepts.
#  This allows us to load a taxonomy parser and assign it concepts without performing the expensive parse
#    operation every time; instead the parse is done here as a one-time operation whenever the source needs updating.

namespace :taxonomy do
  desc 'Load terms to yaml files'
  task load_data: :environment do
    open("#{Rails.root}/spec/fixtures/ita_taxonomies/full_data.zip", 'wb') { |f| f << open(Rails.configuration.protege_url).read }
    parser = TaxonomyParser.new(Rails.configuration.full_protege_source)
    parser.parse
    File.open("#{Rails.root}/spec/fixtures/ita_taxonomies/full_concepts.yaml", 'w') { |f| f.write(parser.concepts.to_yaml) }
    File.open("#{Rails.root}/spec/fixtures/ita_taxonomies/full_concept_groups.yaml", 'w') { |f| f.write(parser.concept_groups.to_yaml) }
    File.open("#{Rails.root}/spec/fixtures/ita_taxonomies/full_concept_schemes.yaml", 'w') { |f| f.write(parser.concept_schemes.to_yaml) }
  end
end
