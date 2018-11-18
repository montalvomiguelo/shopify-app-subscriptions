module Subscriptions
  class App < Sinatra::Base
    set :protection, except: :frame_options

    enable :sessions

    use OmniAuth::Builder do
      provider :shopify, ENV['SHOPIFY_API_KEY'], ENV['SHOPIFY_SHARED_SECRET'], :scope => 'read_products,read_orders,write_content'
    end

    use Shopify::GraphQLProxy

    configure :development do
      register Sinatra::Reloader
    end

    helpers Subscriptions::SessionAuth

    get '/' do
      protected!
    end

    get '/install' do
      erb :install
    end

    post '/login' do
      authenticate!
    end

    get '/logout' do
      session.delete(:shopify)

      redirect '/install'
    end

    get '/auth/shopify/callback' do
      shop_name = env['omniauth.auth'].uid
      token = env['omniauth.auth']['credentials']['token']

      shop = shop_repository.update_or_create(name: shop_name, token: token)

      session[:shopify] = {
        shop: shop_name,
        token: token
      }

      return_to = env['omniauth.params']['return_to']

      redirect return_to
    end

    private

    def shop_repository
      @shop_repository ||= Subscriptions::ShopRepository.new
    end
  end
end
