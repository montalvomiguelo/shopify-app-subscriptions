Sequel.migration do
  change do
    create_table(:shops) do
      primary_key :id
      index :name
      String :name
      String :encrypted_token
      String :encrypted_token_iv
    end
  end
end
