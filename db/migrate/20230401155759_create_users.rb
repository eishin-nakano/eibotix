class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :line_user_id
      t.string :nickname

      t.timestamps
    end
  end
end
