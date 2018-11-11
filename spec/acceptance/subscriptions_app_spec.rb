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
  end
end
