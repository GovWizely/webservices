require 'spec_helper'

describe 'Model field mappings' do
  describe '"id" field mapping' do
    it 'is not present in any model field mappings' do
      Webservices::Application.model_classes.each do |model_class|
        id_field_mapping = model_class.mappings[model_class.index_type][:properties][:id]

        expect(id_field_mapping).to be_nil,
                                    "There's no need to set a field mapping for the 'id' field in "   \
                                    "#{model_class}.mappings, as we remove the field from documents " \
                                    'during our indexing process (see Indexable). On top of the '     \
                                    'mapping being completely unnecessary, it can cause '             \
                                    'RecreateIndicesWithModifiedMappings to behave incorrectly, so '  \
                                    'please remove it from your mappings :-)'
      end
    end

    describe 'when initially inserted into ES' do
      before { Webservices::Application.model_classes.each(&:recreate_index) }

      it 'are not modified by Elasticsearch' do
        Webservices::Application.model_classes.each do |model_class|
          index = model_class.index_name
          db_mapping = ES.client.indices.get_mapping(index: index)[index]['mappings'].deep_stringify

          expect(model_class.mappings.deep_stringify).to eq(db_mapping),
                                                         "#{model_class}.mappings was modified by Elasticsearch after it "  \
                                                         'was put to the DB. The could indicate that your mappings are '    \
                                                         "inconsistent in some way (e.g. setting an analyzer for a 'type: " \
                                                         ":integer' field). Please ensure that Elasticsearch does not "     \
                                                         'modify your mapping'
        end
      end
    end
  end
end
