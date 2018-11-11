module Subscriptions
  class ShopRepository
    def update_or_create(attrs)
      ::Shop.update_or_create(attrs)
    end
  end
end
