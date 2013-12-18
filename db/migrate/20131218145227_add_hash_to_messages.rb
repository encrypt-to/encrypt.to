class AddHashToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :tohash, :string
    add_column :messages, :fromhash, :string
  end
end
