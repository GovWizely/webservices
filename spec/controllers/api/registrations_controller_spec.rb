require 'spec_helper'

describe RegistrationsController, type: :controller do
  describe 'GET regenerate_api_key' do
    # Get an 'Could not find devise mapping for path "/regenerate_api_key".'
    # error without this.
    before { @request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'with a signed-in user' do
      let(:user) { create_user }
      before { sign_in user }

      it "regenerates the user's API key" do
        expect { get :regenerate_api_key }.to change { users_api_key }
        expect(response.status).to eq(302)
        expect(flash[:notice]).to eq('Your API Key has been updated.')
      end

      # Since Elasticsearch::Persistence::Model doesn't give us a convenient
      # way to reload instances, we fetch the api_key each time when checking
      # that it changed.
      def users_api_key
        User.to_adapter.find_first(email: user.email).api_key
      end
    end

    context 'without a signed-in user' do
      it 'responds with 401 unauthorized' do
        get :regenerate_api_key
        expect(response.status).to eq(401)
      end
    end
  end
end
