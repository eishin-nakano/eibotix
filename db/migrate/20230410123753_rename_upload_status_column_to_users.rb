class RenameUploadStatusColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :upload_status, :status
  end
end
