class CreateCurrentProblems < ActiveRecord::Migration[7.0]
  def change
    create_table :current_problems do |t|
      t.integer :user_id
      t.integer :flashcard_id

      t.timestamps
    end
  end
end
