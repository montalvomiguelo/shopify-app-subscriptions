module Subscriptions
  class App < Sinatra::Base
    helpers Subscriptions::SessionAuth

    post '/login' do
      authenticate!
    end
  end
end
