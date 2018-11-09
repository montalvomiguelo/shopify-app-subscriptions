module Subscriptions
  module SessionAuth
    def authenticate!
      shop_name = sanitized_shop_name
      redirect '/install' unless shop_name
      redirect "/auth/shopify?shop=#{shop_name}"
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
  end
end
