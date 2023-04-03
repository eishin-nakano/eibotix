class AddUploadStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :upload_status, :integer
  end
end
