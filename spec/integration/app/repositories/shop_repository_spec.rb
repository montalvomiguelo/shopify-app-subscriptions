module Subscriptions
  RSpec.describe ShopRepository, :database do
    describe '#update_or_create' do
      let(:shop_repository) { Subscriptions::ShopRepository.new }

      it 'successfully saves the shop in database' do
        shop = shop_repository.update_or_create(name: 'snowdevil.myshopify.com', token: 'token')

        expect(shop).to include(
          id: a_kind_of(Integer),
          name: 'snowdevil.myshopify.com',
          token: 'token'
        )
      end
    end
  end
end
