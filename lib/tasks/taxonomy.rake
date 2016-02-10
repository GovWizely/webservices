# Rake task to store a local copy of the Webprotege source XML and also store a copy of its concepts.
#  This allows us to load a taxonomy parser and assign it concepts without performing the expensive parse
#    operation every time; instead the parse is done here as a one-time operation whenever the source needs updating.

namespace :taxonomy do
  desc 'Load geo terms to yaml file'
  task load_geo_terms: :environment do
    open(Rails.configuration.frozen_protege_source, 'wb') { |f| f << open(Rails.configuration.protege_url).read }
    parser = TaxonomyParser.new(Rails.configuration.frozen_protege_source)
    parser.parse
    File.open(Rails.configuration.frozen_taxonomy_concepts, 'w') { |f| f.write(parser.concepts.to_yaml) }
  end
end
