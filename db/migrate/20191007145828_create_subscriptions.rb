class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true, null: false
      t.references :question, foreign_key: true, null: false

      t.index(%i[user_id question_id], unique: true)

      t.timestamps
    end
  end
end
