Sequel.migration do
  change do
    create_table(:shops) do
      primary_key :id
      index :name
      String :name
      String :token
    end
  end
end
