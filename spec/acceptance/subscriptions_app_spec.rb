module Subscriptions
  RSpec.describe 'Subscriptions App', :omniauth, :database do
    include Rack::Test::Methods

    def app
      Subscriptions::App
    end

    context 'when a store is successfully logged in' do
      let(:shop_params) {
        {
          'shop' => 'snowdevil.myshopify.com',
        }
      }

      it 'creates a session for the store' do
        post '/login', shop_params

        follow_redirect!
        follow_redirect!
        expect(last_request.session[:shopify][:token]).to eq('token')
        expect(last_request.session[:shopify][:shop]).to eq('snowdevil.myshopify.com')
      end

      it 'persists the store access token in database' do
        post '/login', shop_params

        follow_redirect!
        follow_redirect!

        shop = ::Shop.first(name: 'snowdevil.myshopify.com')

        expect(shop).not_to be_nil
        expect(shop.name).to eq('snowdevil.myshopify.com')
        expect(shop.token).to eq('token')
      end
    end

    context 'when session exists' do
      let(:rack_env) {
        {
          'rack.session' => {
            :shop => 'snowdevil.myshopify.com',
            :token => 'token'
          }
        }
      }

      it 'allows to access the home page' do
        pending 'Need to protect the home page'

        get '/', {}, rack_env

        expect(last_response).to be_ok
      end
    end

    context 'when session does not exist' do
      it 'does not allow to access the home page' do
        pending 'Need to protect the home page'

        get '/'

        expect(last_response.status).not_to be_ok
      end
    end
  end
end
