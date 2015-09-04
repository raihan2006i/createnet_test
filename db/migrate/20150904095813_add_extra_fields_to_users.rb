class AddExtraFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :job_title, :string
    add_column :users, :address, :text
  end
end
