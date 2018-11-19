class Shop < Sequel::Model
  plugin :update_or_create

  attr_encrypted :token, key: :secret

  def secret
    @secret ||= ENV['SECRET']
  end
end
