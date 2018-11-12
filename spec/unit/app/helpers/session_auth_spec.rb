module Subscriptions
  Request = Struct.new(:path_info)

  RSpec.describe SessionAuth do
    include Rack::Test::Methods

    def app
      Subscriptions::App
    end

    subject do
      Class.new do
        attr_accessor :params, :session, :request

        def initialize(params = {}, session = {})
          @params = params
          @session = session
        end

        include Subscriptions::SessionAuth
      end
    end

    describe '#protected!' do
      context 'when the shop is not logged in' do
        let(:new_subject) { subject.new }
        let(:request) { Request.new('/') }

        it 'authenticates the shop' do
          expect(new_subject).to receive(:authenticate!)
          allow(new_subject).to receive(:request).and_return(request)

          new_subject.protected!
        end
      end

      context 'when the shop is logged in' do
        let(:new_subject) { subject.new({}, { :shopify => { :shop => 'snowdevil.myshopify.com', :token => 'token' } }) }

        it 'does not authenticate the shop' do
          expect(new_subject).not_to receive(:authenticate!)

          new_subject.protected!
        end
      end
    end

    describe '#authenticate!' do
      let(:shop_params) {
        {
          'shop' => 'snowdevil.myshopify.com',
        }
      }

      it 'sanitizes de shop domain' do
        expect_any_instance_of(app).to receive(:sanitized_shop_name)

        post '/login', shop_params
      end

      context 'when the sanitized shop domain is invalid' do
        it 'redirects to the installation page' do
          post '/login', { 'shop' => '' }

          expect(last_response.status).to be(302)
          expect(last_response.location).to include('/install')
        end
      end

      context 'when the sanitized shop domain is valid' do
        it 'redirects to the authentication page' do
          allow_any_instance_of(app).to receive(:sanitized_shop_name).and_return('snowdevil.myshopify.com')

          post '/login', { 'shop' => 'snowdevil.myshopify.com' }

          expect(last_response.status).to be(302)
          expect(last_response.location).to include('/auth/shopify')
        end
      end

      context 'auth url' do
        it 'includes the return_to parameter with a value build with the base url and the return_to value' do
          post '/login', shop_params

          expect(last_response.location).to include('&return_to=http://example.org/')
        end
      end

    end

    describe '#sanitized_shop_name' do
      let(:new_subject) { subject.new(shop: 'snowdevil') }

      it 'sanitizes the shop param' do
        expect(new_subject).to receive(:sanitize_shop_param)

        new_subject.sanitized_shop_name
      end
    end

    describe '#sanitize_shop_param' do
      let(:new_subject) { subject.new }

      context 'when the shop param is not present' do
        it 'returns nil' do
          expect(new_subject.sanitize_shop_param({})).to be(nil)
        end
      end

      context 'when the shop param does not include .myshopify.com domain' do
        it 'appends .myshopify.com to the shop param' do
          expect(new_subject.sanitize_shop_param(shop: 'snowdevil')).to eq('snowdevil.myshopify.com')
        end
      end

      it 'removes the protocol from the shop param' do
        expect(new_subject.sanitize_shop_param(shop: 'https://snowdevil.myshopify.com')).to eq('snowdevil.myshopify.com')
      end

      context 'when the shop param is not a valid URI' do
        it 'returns nil' do
          expect(new_subject.sanitize_shop_param(shop: '.snowdevil')).to be(nil)
        end
      end

      context 'when the shop param is a valid URI' do
        it 'returns the shop domain' do
          expect(new_subject.sanitize_shop_param(shop: 'snowdevil.myshopify.com')).to eq('snowdevil.myshopify.com')
        end
      end
    end
  end
end
