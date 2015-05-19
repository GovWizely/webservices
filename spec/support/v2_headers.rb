shared_context 'V2 headers' do
  before(:all) do
    @user = create_user
    User.gateway.refresh_index!
    @v2_headers = { 'Api-Key' => @user.api_key }
  end
  after(:all) do
    @user.destroy
    User.gateway.refresh_index!
  end
end
