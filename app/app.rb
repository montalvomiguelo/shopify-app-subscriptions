module Subscriptions
  class App < Sinatra::Base
    enable :sessions

    use OmniAuth::Builder do
      provider :shopify, ENV['SHOPIFY_API_KEY'], ENV['SHOPIFY_SHARED_SECRET'], :scope => 'read_products,read_orders,write_content'
    end

    configure :development do
      register Sinatra::Reloader
    end

    helpers Subscriptions::SessionAuth

    get '/install' do
      erb :install
    end

    post '/login' do
      authenticate!
    end

    get '/auth/shopify/callback' do
      shop_name = params[:shop]
      token = env['omniauth.auth']['credentials']['token']

      shop = shop_repository.update_or_create(name: shop_name, token: token)

      session[:shopify] = {
        shop: shop_name,
        token: token
      }

      redirect '/'
    end

    private

    def shop_repository
      @shop_repository ||= Subscriptions::ShopRepository.new
    end
  end
end
