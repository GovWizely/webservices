shared_examples 'a successful search request' do
  specify { expect(subject.status).to eq(200) }
  specify { expect(subject.content_type).to eq(:json) }
end
