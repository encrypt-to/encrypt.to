class AddThanksMessage < ActiveRecord::Migration
  def change
    add_column :users, :thanks_message, :string
  end
end
