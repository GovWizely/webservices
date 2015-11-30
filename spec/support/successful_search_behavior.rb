shared_examples 'a successful search request' do
  specify { expect(subject.status).to eq(200) }
  specify { expect(subject.content_type).to eq(:json) }
  specify do
    response = JSON.parse(subject.body)
    search_time = DateTime.parse(response['search_performed_at'])
    expect(search_time).to be_within(2).of(DateTime.now.utc)
  end
end
