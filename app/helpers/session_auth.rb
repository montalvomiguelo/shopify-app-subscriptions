module Subscriptions
  module SessionAuth
    def authenticate!(return_to = '/')
      shop_name = sanitized_shop_name
      redirect '/install' unless shop_name
      redirect "/auth/shopify?shop=#{shop_name}&return_to=#{base_url}#{return_to}"
    end

    def base_url
      @base_url ||= request.base_url
    end

    def sanitized_shop_name
      @sanitized_shop_name || sanitize_shop_param(params)
    end

    def sanitize_shop_param(params)
      return unless params[:shop].present?
      name = params[:shop].to_s.strip
      name += '.myshopify.com' if !name.include?('myshopify.com') && !name.include?('.')
      name.gsub!('https://', '')
      name.gsub!('http://', '')

      uri = URI("http://#{name}")
      uri.host.ends_with?('.myshopify.com') ? uri.host : nil
    end

    def protected!
      unless session.key?(:shopify)
        return_to = request.path_info

        authenticate!(return_to)
      end
    end

    def current_shop_name
      return session[:shopify][:shop]
    end
  end
end
