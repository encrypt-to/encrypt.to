class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.text :public_key

      t.timestamps
    end
  end
end
