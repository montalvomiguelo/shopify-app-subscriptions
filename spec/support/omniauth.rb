RSpec.configure do |config|
  config.before(:suite) do
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:shopify] = OmniAuth::AuthHash.new({
      :provider => 'shopify',
      :uid => 'snowdevil.myshopify.com',
      :credentials => { :token => 'token' }
    })
  end
end
