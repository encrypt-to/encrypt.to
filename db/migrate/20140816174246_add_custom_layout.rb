class AddCustomLayout < ActiveRecord::Migration
  def change
    add_column :users, :css_form_background, :string
    add_column :users, :css_form_color, :string
    add_column :users, :form_attachment, :boolean, default: true
    add_column :users, :form_advanced_mode, :boolean, default: true
  end
end
