require 'spec_helper'

describe Envirotech::RelationalData do
  shared_examples 'it sets all relational data as expected' do
    include_context 'empty Envirotech indices'
    include_context 'Envirotech::Issue data'
    include_context 'Envirotech::Solution data'
    include_context 'Envirotech::Regulation data'

    it 'imports relational data' do
      issue = fetch('issues', 'Biosolid/Sludge Management, Use, or Disposal')
      regulation = fetch('regulations', 'Standards of Performance for New Stationary Sources: Oil and Gas')
      solution = fetch('solutions', 'Mercury - Electrostatic Precipitators')

      expect(issue[:regulation_ids]).to eq([])
      expect(issue[:solution_ids]).to eq([])
      expect(regulation[:issue_ids]).to eq([])
      expect(regulation[:solution_ids]).to eq([])
      expect(solution[:regulation_ids]).to eq([])
      expect(solution[:issue_ids]).to eq([])

      subject

      issue = fetch('issues', 'Biosolid/Sludge Management, Use, or Disposal')
      regulation = fetch('regulations', 'Standards of Performance for New Stationary Sources: Oil and Gas')
      solution = fetch('solutions', 'Mercury - Electrostatic Precipitators')

      expect(issue[:regulation_ids]).to eq([regulation[:source_id]])
      expect(issue[:solution_ids]).to eq([solution[:source_id]])
      expect(regulation[:issue_ids]).to eq([issue[:source_id]])
      expect(regulation[:solution_ids]).to eq([solution[:source_id]])
      expect(solution[:regulation_ids]).to eq([regulation[:source_id]])
      expect(solution[:issue_ids]).to eq([issue[:source_id]])
    end
  end

  context 'when a single import is performed' do
    subject { import }
    it_behaves_like 'it sets all relational data as expected'
  end

  context 'when multiple imports are performed' do
    subject do
      import
      import
    end
    it_behaves_like 'it sets all relational data as expected'
  end

  def fetch(source, name)
    Envirotech::Consolidated
      .search_for(sources: source,)[:hits]
      .map { |h| h[:_source] }
      .find { |h| h[:name_english] == name }
  end

  def import
    importer = described_class.new
    relations_filename = "#{Rails.root}/spec/fixtures/envirotech/relations.json"
    relations = JSON.parse(open(relations_filename).read)
    importer.instance_variable_set(:@relations, relations)
    importer.import
  end
end
