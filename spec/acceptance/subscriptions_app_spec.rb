module Subscriptions
  RSpec.describe 'Subscriptions App', :omniauth, :database, :webmock do
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
      before :each do
        env 'rack.session', {
          :shopify => {
            :shop => 'snowdevil.myshopify.com',
            :token => 'token'
          }
        }
      end

      it 'allows to access the home page' do
        get '/'

        expect(last_response).to be_ok
      end

      it 'allows to fetch data with graphql' do
        stub_request(:post, "http://snowdevil.myshopify.com/admin/api/graphql.json").
          with(
            body: '{"query":"{ shop { name } }"}',
            headers: {
              'Content-Length'=>'29',
              'Content-Type'=>'application/json',
              'Host'=>'snowdevil.myshopify.com',
              'X-Forwarded-For'=>'127.0.0.1',
              'X-Shopify-Access-Token'=>'token'
            }).
            to_return(status: 200, body: '{"data":{"shop":{"name":"Snowdevil"}},"extensions":{"cost":{"requestedQueryCost":1,"actualQueryCost":1,"throttleStatus":{"maximumAvailable":1000.0,"currentlyAvailable":999,"restoreRate":50.0}}}}', headers: {})

        env 'CONTENT_TYPE', 'application/json'

        post '/graphql', '{"query":"{ shop { name } }"}'

        parsed = JSON.parse(last_response.body)

        expect(parsed['data']).to eq({ 'shop'=>{ 'name'=>'Snowdevil' } })
      end
    end

    context 'when session does not exist' do
      it 'does not allow to access the home page' do
        get '/'

        expect(last_response).not_to be_ok
      end
    end
  end
end
