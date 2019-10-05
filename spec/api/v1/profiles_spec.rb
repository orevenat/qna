require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:headers) { { "ACCEPT" => "application/json"} }
  let(:params) { { access_token: access_token.token } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { 'get' }
    end

    context 'authorized' do
      let(:content) { json['user'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request sucessfull status'

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(content[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(content).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { 'get' }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:content) { json['users'].first }
      let(:user) { users.first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request sucessfull status'

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(content[attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(content).to_not have_key(attr)
        end
      end
    end
  end
end
