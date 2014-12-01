shared_examples 'an empty result' do
  subject { JSON.parse(response.body)['results'].length }
  it { is_expected.to eq(0) }
end

shared_examples "an empty result when a query doesn't match any documents" do
  let(:params) { { q: 'asdzxcasd' } }
  it_behaves_like 'an empty result'
end

shared_examples "an empty result when an industries search doesn't match any documents" do
  let(:params) { { industries: 'asdzxcasd' } }
  it_behaves_like 'an empty result'
end

shared_examples "an empty result when an industry search doesn't match any documents" do
  let(:params) { { industry: 'asdzxcasd' } }
  it_behaves_like 'an empty result'
end

shared_examples "an empty result when a country search doesn't match any documents" do
  let(:params) { { country: 'YY' } }
  it_behaves_like 'an empty result'
end

shared_examples "an empty result when a countries search doesn't match any documents" do
  let(:params) { { countries: 'YY' } }
  it_behaves_like 'an empty result'
end
