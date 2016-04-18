shared_context 'ItaTaxonomy data' do
  before(:all) do
    ItaTaxonomy.recreate_index
    ItaTaxonomy.index(YAML.load_file("#{Rails.root}/spec/fixtures/ita_taxonomies/full_related_terms.yaml"))
  end

  after(:all) { ItaTaxonomy.recreate_index }
end
