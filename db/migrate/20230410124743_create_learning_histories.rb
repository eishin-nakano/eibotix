class CreateLearningHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_histories do |t|
      t.integer :user_id
      t.integer :flashcard_id
      t.integer :correct

      t.timestamps
    end
  end
end
