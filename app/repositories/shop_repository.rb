module Subscriptions
  class ShopRepository
    def update_or_create(attrs, set_attrs)
      ::Shop.update_or_create(attrs, set_attrs)
    end
  end
end
