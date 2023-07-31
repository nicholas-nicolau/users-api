class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    
    create_table(:users) do |t|
      t.integer :age, null: false
      t.string :name, null: false
      t.string :email, null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :name
  end
end
