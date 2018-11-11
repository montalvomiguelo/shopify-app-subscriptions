module Subscriptions
  Shop = Struct.new(:id, :name, :token)

  RSpec.describe App do
    include Rack::Test::Methods

    def app
      Subscriptions::App
    end

    def update_or_create_shop
      shop = Shop.new(1, 'snowdevil.myshopify.com', 'token')

      expect_any_instance_of(Subscriptions::ShopRepository).to receive(:update_or_create)
        .with(name: 'snowdevil.myshopify.com', token: 'token')
        .and_return(shop)
    end

    describe 'POST /login' do
      let(:shop_params) {
        {
          'shop' => 'snowdevil.myshopify.com',
        }
      }

      it 'authenticates the store' do
        expect_any_instance_of(app).to receive(:authenticate!)

        post '/login', shop_params
      end
    end

    describe 'GET /auth/shopify/callback' do
      let(:params) {
        { 'shop' => 'snowdevil.myshopify.com' }
      }

      let(:rack_env) {
        {
          'omniauth.auth' => {
            'credentials' => {
              'token' => 'token'
            }
          }
        }
      }

      it 'responds with a 302 (Redirect)' do
        update_or_create_shop

        get '/auth/shopify/callback', params, rack_env

        expect(last_response.status).to eq(302)
      end

      it 'updates or creates the shop in data base' do
        update_or_create_shop

        get '/auth/shopify/callback', params, rack_env
      end

      it 'creates a session for the shop' do
        update_or_create_shop

        get '/auth/shopify/callback', params, rack_env

        expect(last_request.session[:shopify]).not_to be_nil
        expect(last_request.session[:shopify][:shop]).to eq('snowdevil.myshopify.com')
        expect(last_request.session[:shopify][:token]).to eq('token')
      end
    end
  end
end
