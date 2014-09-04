shared_examples 'a successful search request' do
  its(:status) { should == 200 }
  its(:content_type) { should == :json }
end
