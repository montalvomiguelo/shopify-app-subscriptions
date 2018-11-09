require_relative '../../../app/app'

module Subscriptions
  RSpec.describe App do
    include Rack::Test::Methods

    def app
      Subscriptions::App
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
  end
end
