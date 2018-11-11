module Subscriptions
  class App < Sinatra::Base
    helpers Subscriptions::SessionAuth

    enable :sessions

    configure :development do
      register Sinatra::Reloader
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
