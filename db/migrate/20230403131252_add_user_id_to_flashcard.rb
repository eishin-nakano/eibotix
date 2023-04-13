class AddUserIdToFlashcard < ActiveRecord::Migration[7.0]
  def change
    add_column :flashcards, :user_id, :integer
  end
end
