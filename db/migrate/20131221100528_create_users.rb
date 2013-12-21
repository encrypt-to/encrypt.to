class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :public_key

      t.timestamps
    end
  end
end
