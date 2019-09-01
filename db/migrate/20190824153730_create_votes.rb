class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.integer :value, default: 0, null: false
      t.references :votable, polymorphic: true

      t.index(%i[user_id votable_type votable_id], unique: true)

      t.timestamps
    end
  end
end
