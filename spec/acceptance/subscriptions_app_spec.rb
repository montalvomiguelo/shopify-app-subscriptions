require_relative '../../app/app'

module Subscriptions
  RSpec.describe 'Subscriptions App' do
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
        pending 'Need to create a session for the store'
        post '/login', shop_params

        expect(last_response).to be_ok
        expect(last_request.session[:shopify][:token]).to eq('token')
        expect(last_request.session[:shopify][:shop]).to eq('snowdevil.myshopify.com')
      end

      it 'persists the store access token in data base' do
        pending 'Need to persist the store in data base'
        post '/login', shop_params

        shop = Shop.first(name: 'snowdevil.myshopify.com')

        expect(shop).not_to be_nil
        expect(shop.name).to eq('snowdevil.myshopify.com')
        expect(shop.access_token).to eq('token')
      end
    end
  end
end
